return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Keep your existing JDTLS setting (prevents conflict)
        jdtls = false,

        -- === ADD LEMMINX HERE ===
        lemminx = {
          settings = {
            xml = {
              fileAssociations = {
                {
                  -- This forces Lemminx to treat pom.xml as a Maven file
                  systemId = "https://maven.apache.org/xsd/maven-4.0.0.xsd",
                  pattern = "pom.xml",
                },
              },
            },
          },
        },
      },
    },
  },
}
