return {
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      -- 1. The Standard Menus
      { "<leader>mm", "<cmd>Maven<cr>",     desc = "Maven Menu" },
      { "<leader>mr", "<cmd>MavenExec<cr>", desc = "Maven Exec" },

      -- 2. RELOAD PROJECT (The IntelliJ "Reload" Button)
      {
        "<leader>mu",
        function()
          if vim.bo.filetype == "java" then
            require("jdtls").update_project_config()
            vim.notify("JDTLS: Reloading Maven Config...", vim.log.levels.INFO)
          else
            vim.notify("Not a Java buffer", vim.log.levels.WARN)
          end
        end,
        desc = "Reload Maven Config (Force Sync)"
      },

      -- 3. Check for Dependency Updates (Moved to 'v')
      {
        "<leader>mv",
        function()
          local cmd = "mvn versions:display-dependency-updates"
          vim.notify("Checking for library updates...", vim.log.levels.INFO)
          require("snacks").terminal(cmd, {
            win = { style = "float", position = "float" },
            interactive = false,
          })
        end,
        desc = "Check Maven Versions"
      },
    },
    config = function()
      -- SMART DETECTION: Check if 'mvnw' exists
      local mvn_cmd = "mvn"
      if vim.fn.filereadable("mvnw") == 1 or vim.fn.filereadable("mvnw.cmd") == 1 then
        mvn_cmd = "./mvnw"
      end

      require("maven").setup({
        executable = mvn_cmd,
        commands = {
          { cmd = { "spring-boot:run" },                            desc = "Run Spring Boot App" },
          { cmd = { "clean", "install" },                           desc = "Clean Install" },
          { cmd = { "clean", "package", "-DskipTests" },            desc = "Build (Skip Test Execution)" },
          { cmd = { "clean", "package", "-Dmaven.test.skip=true" }, desc = "Build (Ignore Tests Completely)" },
          { cmd = { "test" },                                       desc = "Run All Tests" },
          { cmd = { "dependency:tree" },                            desc = "Show Dependency Tree" },
        },
      })
    end,
  },
}
