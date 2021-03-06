import qbs 1.0
import LiriUtils

LiriModuleProject {
    id: root

    name: "Qt5Udev"
    moduleName: "Qt5Udev"
    description: "Qt API for udev"
    pkgConfigDependencies: ["Qt5Core", "libudev"]
    createCMake: false

    resolvedProperties: ({
        Depends: [{ name: LiriUtils.quote("Qt.core") },
                  { name: LiriUtils.quote("libudev") }],
    })

    LiriHeaders {
        name: root.headersName
        sync.module: root.moduleName
        sync.classNames: ({
            "udevdevice.h": ["UdevDevice"],
            "udevenumerate.h": ["UdevEnumerate"],
            "udev.h": ["Udev"],
            "udevmonitor.h": ["UdevMonitor"],
        })

        Group {
            name: "Headers"
            files: "**/*.h"
            fileTags: ["hpp_syncable"]
        }
    }

    LiriModule {
        name: root.moduleName
        targetName: root.targetName
        version: "1.0.0"

        Depends { name: root.headersName }
        Depends {
            name: "Qt.core"
            versionAtLeast: project.minimumQtVersion
        }
        Depends { name: "libudev" }

        condition: {
            if (!libudev.found) {
                console.error("libudev is required to build " + targetName);
                return false;
            }

            return true;
        }

        cpp.defines: base.concat([
            'QTUDEV_VERSION="' + project.version + '"',
            "LIRI_BUILD_QTUDEV_LIB"
        ])

        files: ["*.cpp", "*.h"]

        Export {
            Depends { name: "cpp" }
            Depends { name: root.headersName }
            Depends { name: "Qt.core" }
            Depends { name: "libudev" }
        }
    }
}
