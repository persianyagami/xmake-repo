package("spirv-tools")

    set_homepage("https://github.com/KhronosGroup/SPIRV-Tools/")
    set_description("SPIR-V Tools")
    set_license("Apache-2.0")

    add_urls("https://github.com/KhronosGroup/SPIRV-Tools/archive/v$(version).tar.gz")
    add_versions("2020.5", "947ee994ba416380bd7ccc1c6377ac28a4802a55ca81ccc06796c28e84c00b71")

    add_patches("2020.5", "https://github.com/KhronosGroup/SPIRV-Tools/commit/a1d38174b1f7d2651c718ae661886d606cb50a32.patch", "2811faeef3ad53a83e409c8ef9879badcf9dc04fc3d98dbead7313514b819933")

    add_deps("cmake")
    add_deps("spirv-headers", "python 3.x")

    on_install("linux", "windows", "macosx", function (package)
        package:addenv("PATH", "bin")
        local configs = {"-DSPIRV_SKIP_TESTS=ON"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        local spirv = package:dep("spirv-headers")
        table.insert(configs, "-DSPIRV-Headers_SOURCE_DIR=" .. spirv:installdir():gsub("\\", "/"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        os.runv("spirv-as --help")
        os.runv("spirv-opt --help")
    end)
