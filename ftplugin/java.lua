-- /home/james/.config/nvim/ftplugin/java.lua
-- === DEBUG STEP 1: See if this file is running ===
vim.notify("JDTLS ftplugin: Executing for " .. vim.api.nvim_buf_get_name(0), vim.log.levels.INFO, { title = "JDTLS" })

local home = vim.env.HOME
local jdtls = require("jdtls")

-- === ADDITION 1: Load spring-boot.nvim and init commands ===
local spring_boot_ok, spring_boot = pcall(require, "spring_boot")
if spring_boot_ok then
  spring_boot.init_lsp_commands()
  vim.notify("JDTLS ftplugin: spring-boot.nvim loaded", vim.log.levels.INFO, { title = "JDTLS" })
else
  vim.notify("JDTLS ftplugin: require('spring_boot') failed!", vim.log.levels.WARN, { title = "JDTLS" })
end
-- ==========================================================

if not jdtls then
  vim.notify("JDTLS ftplugin: require('jdtls') failed!", vim.log.levels.ERROR, { title = "JDTLS" })
  return
end

-- === DEBUG STEP 2: See what root_dir is found ===
local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

vim.notify("JDTLS ftplugin: Found root_dir: " .. tostring(root_dir), vim.log.levels.INFO, { title = "JDTLS" })

if root_dir == nil or root_dir == "" then
  vim.notify(
    "JDTLS ftplugin: No project root found. Attaching in single-file mode.",
    vim.log.levels.WARN,
    { title = "JDTLS" }
  )
  -- Attempt to attach in single-file mode
  root_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
end

-- === Your Original Configuration Starts Here ===

local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local system_os = vim.fn.has("mac") == 1 and "mac" or vim.fn.has("win32") == 1 and "win" or "linux"
local mason = home .. "/.local/share/nvim/mason/packages"

-- === BUNDLES (skip problematic JARs) ===
local bundles = {
  vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}
local test_dir = mason .. "/java-test/extension/server"
local test_jars = vim.fn.glob(test_dir .. "/*.jar", true)
if test_jars ~= "" then
  for _, jar in ipairs(vim.split(test_jars, "\n")) do
    local name = vim.fn.fnamemodify(jar, ":t")
    if not (name:match("^com.microsoft.java.test.runner") or name:match("^jacocoagent")) then
      table.insert(bundles, jar)
    end
  end
end

-- === ADDITION 2: Add Spring Boot extensions to bundles ===
if spring_boot_ok then
  vim.notify("JDTLS ftplugin: Loading spring-boot.nvim extensions", vim.log.levels.INFO, { title = "JDTLS" })
  local spring_boot_extensions = spring_boot.java_extensions()
  vim.list_extend(bundles, spring_boot_extensions)
end
-- ========================================================

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. mason .. "/jdtls/lombok.jar",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(mason .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true),
    "-configuration",
    mason .. "/jdtls/config_" .. system_os,
    "-data",
    workspace_dir,
  },

  root_dir = root_dir, -- Use the dynamically found root_dir

  settings = {
    java = {
      home = "/usr/lib/jvm/java-25-openjdk/",
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          { name = "JavaSE-21", path = "/home/james/.sdkman/candidates/java/21.0.8-tem/" },
          { name = "JavaSE-25", path = "/usr/lib/jvm/java-25-openjdk/" },
        },
      },
      maven = { downloadSources = true },
      spring = { boot = { enabled = true } },

      project = {
        outputPath = "target/classes", -- Maven
      },

      sourcePaths = {
        "src/main/java",
        "src/test/java",
      },

      -- Rest of your settings...
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      format = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        useBlocks = true,
      },
    },
  },

  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = { allow_incremental_sync = true },

  -- *** THIS IS THE FIX ***
  -- It was 'ind_options' before, which is a syntax error.
  init_options = {
    bundles = bundles, -- This 'bundles' table now includes the Spring Boot ones
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

-- === ON_ATTACH: DAP with proper source mapping ===
config.on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil
  -- This will be called for each buffer
  jdtls.setup_dap({ hotcodereplace = "auto" })

  require("jdtls.dap").setup_dap_main_class_configs({
    config_overrides = {
      vmArgs = "-Dspring.profiles.active=dev",
      sourcePaths = { "src/main/java", "src/test/java" },
    },
  })

  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<F5>", function()
    if require("dap").session() then
      require("dap").continue()
    else
      require("dap").continue()
    end
  end, opts)

  vim.keymap.set("n", "<leader>sb", function()
    require("jdtls.dap").runSpringBoot()
  end, opts)
end

-- This is the final, most important call.
-- This will run every time you open a java file.
jdtls.start_or_attach(config)
