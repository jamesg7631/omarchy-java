return {
  {
    "mason-org/mason.nvim", -- This line is correct
    -- This 'opts' function will merge with LazyVim's defaults
    opts = function(_, opts)
      -- 'opts.ensure_installed' is the list of tools Mason will install
      vim.list_extend(opts.ensure_installed, {
        -- Your list, now with all correct package names
        "debugpy",
        "groovy-language-server", -- Fixed: was "groovyls"
        "lua-language-server", -- Fixed: was "lua_ls"
        "jdtls",
        "json-lsp", -- Fixed: was "jsonls"
        "lemminx",
        "marksman",
        "quick-lint-js", -- Fixed: was "quick_lint_js"
        "yaml-language-server", -- Fixed: was "yamlls"
        "pyright",
        "black",
        "css-lsp",
        "html-lsp",
        "prettier",
        "shfmt",
        "stylua",
        "java-debug-adapter",
        "java-test",
      })
    end,
  },
}
