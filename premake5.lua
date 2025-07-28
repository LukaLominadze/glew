-- Set project name and version
project "GLEW"
    kind "StaticLib"   -- Change this to "SharedLib" if you want a shared library.
    language "C"
    staticruntime "off"
    
    -- Define installation paths
    targetdir ("%{wks.location}/bin/" ..outputdir.. "/%{prj.name}")
    objdir ("%{wks.location}/bin-int/" ..outputdir.. "/%{prj.name}")
    includedirs { "include" }
    libdirs { "%{prj.location}/lib" }

    -- Source files
    files {
        "src/glew.c",
        "include/GL/glew.h",
        "include/GL/wglew.h",
        "include/GL/glxew.h"
    }

    -- Define configurations
    filter "system:windows"
        systemversion "latest"
        links { "opengl32" }

    filter "system:linux"
    	systemversion "latest"
        links { "GL" }

        prebuildcommands {
            "mkdir -p $(GLEW_DEST)/bin",
            "mkdir -p $(GLEW_DEST)/include/GL"
        }
        
        postbuildcommands {
            "cp -r include/* $(GLEW_DEST)/include/GL/",
            "cp lib/libGLEW.a $(GLEW_DEST)/lib/",
            "cp bin/glewinfo $(GLEW_DEST)/bin/",
            "cp bin/visualinfo $(GLEW_DEST)/bin/"
        }
        
    -- Define different build configurations
    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        runtime "Debug"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
        runtime "Release"


