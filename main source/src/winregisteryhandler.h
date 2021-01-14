#ifndef REGISTRYHANDLER_H
#define REGISTRYHANDLER_H

/*
 *
 *
 *
 *
 *
 */

#include <QObject>
#include <QQuickItem>
#include <QDir>

#include <stdlib.h>

#ifdef WIN32
    #include <Windows.h>
    #include <winreg.h>
#endif

class winRegisteryHandler : public QQuickItem
{
    Q_OBJECT
public:
    winRegisteryHandler();

    /*!
     * \brief createRegKey
     * the registery structure key illustrated in below.
     * .
     * └── HKEY_CLASSES_ROOT
     *     └── *
     *         └── shell
     *             └── addToSF
     *                 ├── (Default) = &add to sub fixer
     *                 └── command
     *                     └── (Default) = "c:/path/to/my/program" /add "%1"
     *
     * \link https://docs.microsoft.com/en-us/windows/win32/shell/context-menu-handlers?redirectedfrom=MSDN
     * \return
     */
    bool addToContextMenu()
    {
        bool error = true;
#ifdef WIN32
        //ElevateToAdministrator();
        QString curPath = "\"" + QCoreApplication::applicationDirPath() + "/" +
                          QCoreApplication::applicationName() + ".exe\" \add \"%1\"";
        wchar_t programDir[290]{};
        curPath.toWCharArray(programDir);

        error &= createRegistryKey(HKEY_CLASSES_ROOT,L"*\\shell\\addToSF\\command");
        error &= writeStringInRegistry(HKEY_CLASSES_ROOT,L"*\\shell\\addToSF",nullptr,
                                       L"&add To SubFixer");
        error &= writeStringInRegistry(HKEY_CLASSES_ROOT,L"*\\shell\\addToSF\\command",nullptr,
                                       programDir);

#endif
        return error;
    }

    bool createRegistryKey(HKEY hKeyParent,const wchar_t subkey[])
    {
#ifdef WIN32
        unsigned long dwDisposition;
        HKEY  hKey;
        long errorCode;
        errorCode = RegCreateKeyEx(hKeyParent,
                             subkey,
                             0,nullptr,
                             REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,
                             nullptr,&hKey,
                             &dwDisposition);

        if (errorCode != ERROR_SUCCESS)
        {
            printf("Error opening or creating key.\n");
            return false;
        }
        RegCloseKey(hKey);
        return true;
#else
        return false;
#endif
    }


    bool writeStringInRegistry(HKEY hKeyParent,const wchar_t subkey[],const wchar_t valueName[],const wchar_t strData[])
    {
#ifdef WIN32
        long errorCode;
        HKEY hKey;
        //Check if the registry exists
        errorCode = RegOpenKeyEx(hKeyParent,subkey,0,KEY_SET_VALUE,&hKey);
        if (errorCode == ERROR_SUCCESS)
        {
             LONG errorCode = RegSetValueEx(hKey,valueName,0,REG_SZ,
                                     reinterpret_cast<const unsigned char *>(strData),
                                     (lstrlen(strData) + 1) * 2);
            if (errorCode != ERROR_SUCCESS)
            {
                RegCloseKey(hKey);
                return false;
            }
            RegCloseKey(hKey);
            return true;
        }
        return false;
#else
        return false;
#endif
    }


    static bool ElevateToAdministrator()
    {
        wchar_t szPath[MAX_PATH];
        if (GetModuleFileName(nullptr, szPath, ARRAYSIZE(szPath)))
        {
            SHELLEXECUTEINFO sei = {sizeof(sei)};

            sei.lpVerb = L"runas";
            sei.lpFile = szPath;
            sei.hwnd = nullptr;
            sei.nShow = SW_NORMAL;

            if (!ShellExecuteEx(&sei))
            {
                DWORD dwError = GetLastError();
                if (dwError == ERROR_CANCELLED)
                    CreateThread(nullptr,0,reinterpret_cast<LPTHREAD_START_ROUTINE>(ElevateToAdministrator),nullptr,0,nullptr);
            }
        }
        return true;
    }

signals:

public slots:

};

#endif // REGISTRYHANDLER_H
