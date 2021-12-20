workspace "Havtorn"
	architecture "x86_64"
	location "Source"

	configurations
	{ "Debug", "Release" }
	startproject "Launcher"

outputdir = "%{cfg.buildcfg}_%{cfg.system}_%{cfg.architecture}"
engineProj = "Engine"
engineSource = "Source/" .. engineProj .. "/"

project "Engine"
	location "Source/Engine"
	kind "SharedLib"
	language "C++"
	cppdialect "C++20"
	architecture "x86_64"

	targetname "%{prj.name}_%{cfg.buildcfg}"

	targetdir ("Bin/" .. outputdir .. "/%{prj.name}") 
	objdir ("Temp/" .. outputdir .. "/%{prj.name}") 

	warnings "Extra"
	flags { "FatalWarnings", "ShadowedVariables" }

	pchheader "hvpch.h"
	pchsource "Source/Engine/hvpch.cpp"
	forceincludes { "hvpch.h" }

	files 
	{
		"Source/%{prj.name}/**.h",
		"Source/%{prj.name}/**.cpp",
		
		vpaths 
		{
			["*"] = "Source/"
		}
	}

	includedirs
	{
		"Source/%{prj.name}",
		"External/spdlog/include",
		"External/FastNoise2/include",
		"External/rapidjson",
		"External/imgui"
	}

	libdirs {  }

	floatingpoint "Fast"
	debugdir "Bin/"

	filter "system:Windows"
		staticruntime "On"
		systemversion "latest"
		vectorextensions "SSE4.1"

		defines 
		{
			"HV_PLATFORM_WINDOWS",
			"HV_BUILD_DLL"
		}

		postbuildcommands
		{
			"{MKDIR} ../../Bin/",
			"{COPY} %{cfg.buildtarget.relpath} ../../Bin/"
		}

	filter "configurations:Debug"
		defines "HV_DEBUG"
		buildoptions "/MDd"
		staticruntime "off"
		runtime "Debug"
		symbols "On"

		defines 
		{
			"HV_ENABLE_ASSERTS"
		}

	filter "configurations:Release"
		defines "HV_RELEASE"
		buildoptions "/MD"
		staticruntime "off"
		runtime "Release"
		optimize "On"
		flags { "LinkTimeOptimization" }

project "Launcher"
	location "Source/Launcher"
	kind "WindowedApp"
	language "C++"
	cppdialect "C++20"
	architecture "x86_64"

	targetname "%{prj.name}_%{cfg.buildcfg}"

	targetdir ("Bin/" .. outputdir .. "/%{prj.name}") 
	objdir ("Temp/" .. outputdir .. "/%{prj.name}") 

	warnings "Extra"
	flags { "FatalWarnings", "ShadowedVariables" }

	files
	{
		"Source/%{prj.name}/**.h",
		"Source/%{prj.name}/**.cpp",

		vpaths 
		{
			["*"] = "Source/"
		}
	}

	includedirs
	{
		"Source/%{prj.name}",
		"External/spdlog/include",
		"Source/Engine"
	}

	links
	{
		"Engine"
	}

	floatingpoint "Fast"
	debugdir "Bin/"

	filter "system:Windows"
		staticruntime "On"
		systemversion "latest"
		vectorextensions "SSE4.1"

		defines 
		{
			"HV_PLATFORM_WINDOWS"
		}
		
		postbuildcommands
		{
			"{MKDIR} ../../Bin/",
			"{COPY} %{cfg.buildtarget.relpath} ../../Bin/"
		}

	filter "configurations:Debug"
		defines "HV_DEBUG"
		buildoptions "/MDd"
		staticruntime "off"
		runtime "Debug"
		symbols "On"

		defines 
		{
			"HV_ENABLE_ASSERTS"
		}

	filter "configurations:Release"
		defines "HV_RELEASE"
		buildoptions "/MD"
		staticruntime "off"
		runtime "Release"
		optimize "On"
		flags { "LinkTimeOptimization" }