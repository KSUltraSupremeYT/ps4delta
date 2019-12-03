
-- reconfigure paths with qt support
premake.path = premake.path .. ";build"
package.path = package.path .. ";../tools/premake/premake-qt/?.lua"

-- qt support 
require("qt")
qt = premake.extensions.qt

workspace "PS4Delta"
    configurations { "Debug", "Release" }

	location "../build"
	os.mkdir"../build/symbols"
	
	platforms { "x64" }
    targetprefix ""
    buildoptions "/std:c++17"
    symbols "On"
    characterset "Unicode"
	
	-- multi threaded compilation
	flags "MultiProcessorCompile"
	
    pic "On"
    startproject "host"
	targetdir '../bin/%{cfg.buildcfg}/'
	
	
    defines { "FXNAME=\"%{wks.name}\"", 
			  "FXNAME_WIDE=L\"%{wks.name}\""}

	libdirs
	{
		"./shared/Lib",
	}
	
    filter "platforms:x64"
         architecture "x86_64"

    filter "configurations:Debug"
        defines { "DELTA_DBG" }

    filter "configurations:Release"
        optimize "Speed"

    filter {"system:windows", "kind:not StaticLib"}
         linkoptions { "/PDB:\"$(SolutionDir)\\symbols\\$(ProjectName)_%{cfg.buildcfg}.pdb\"" }

    filter { "system:windows", "kind:not StaticLib" }
        linkoptions "/manifestdependency:\"type='Win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\""

    -- Disable deprecation warnings and errors
    filter "action:vs*"
        defines
        {
			"NOMINMAX",
			"WIN32_LEAN_AND_MEAN",
			"_SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING",
			"_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING",
            "_CRT_SECURE_NO_WARNINGS",
            "_CRT_SECURE_NO_DEPRECATE",
            "_CRT_NONSTDC_NO_WARNINGS",
            "_CRT_NONSTDC_NO_DEPRECATE",
            "_SCL_SECURE_NO_WARNINGS",
            "_SCL_SECURE_NO_DEPRECATE"
        }

    group "core"
	include "./delta"
	include "./shared"
	
	group "tools"
	include "tools/sedit"
	include "tools/unpup"
	include "tools/imputil"
	
-- Cleanup
if _ACTION == "clean" then
    os.rmdir("../bin");
    os.rmdir("../build");
end
