return {
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      -- 1. Standard Maven Menus
      { "<leader>mm", "<cmd>Maven<cr>",     desc = "Maven Menu" },
      { "<leader>mr", "<cmd>MavenExec<cr>", desc = "Maven Exec" },

      -- 2. RELOAD PROJECT (Force Sync / Fix Red Text)
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

      -- 3. Check for Dependency Updates
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

      -- 4. NEW: The "Instant" Project Wizard (With launch.json support)
      {
        "<leader>mn",
        function()
          local input = vim.fn.input

          -- Ask for Project Name
          local name = input("Project Name: ")
          if name == "" then return end

          -- Ask for Group ID
          local group = input("Group ID (e.g., com.example): ", "com.example")

          -- Ask for Java Version
          vim.ui.select({ "8", "11", "17", "21", "23", "25" }, { prompt = "Select Java Version:" }, function(java_ver)
            if not java_ver then return end

            -- SMART FIX: Java 8 is historically written as "1.8" in pom.xml
            local compiler_ver = java_ver
            if java_ver == "8" then compiler_ver = "1.8" end

            -- Generate Paths
            local root = vim.fn.getcwd() .. "/" .. name
            local package_path = group:gsub("%.", "/")
            local src_main = root .. "/src/main/java/" .. package_path
            local src_test = root .. "/src/test/java/" .. package_path
            local vscode_dir = root .. "/.vscode"

            -- Create Folders
            vim.fn.mkdir(src_main, "p")
            vim.fn.mkdir(src_test, "p")
            vim.fn.mkdir(vscode_dir, "p")

            -- Create POM.xml
            local pom_content = string.format([[
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>%s</groupId>
    <artifactId>%s</artifactId>
    <version>1.0-SNAPSHOT</version>
    <properties>
        <maven.compiler.source>%s</maven.compiler.source>
        <maven.compiler.target>%s</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>]], group, name, compiler_ver, compiler_ver)

            -- Create App.java
            local app_content = string.format([[
package %s;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Java " + System.getProperty("java.version"));
    }
}
]], group)

            -- Create .vscode/launch.json (Dynamic based on project info)
            local launch_content = string.format([[
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Current File",
      "request": "launch",
      "mainClass": "${file}"
    },
    {
      "type": "java",
      "name": "App",
      "request": "launch",
      "mainClass": "%s.App",
      "projectName": "%s"
    }
  ]
}
]], group, name)

            -- Write Files
            local function write_file(path, content)
              local f = io.open(path, "w")
              f:write(content)
              f:close()
            end

            write_file(root .. "/pom.xml", pom_content)
            write_file(src_main .. "/App.java", app_content)
            write_file(vscode_dir .. "/launch.json", launch_content)

            vim.notify("Created Project: " .. name .. " (Java " .. java_ver .. ")", vim.log.levels.INFO)
          end)
        end,
        desc = "Create New Maven Project (Instant)"
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
