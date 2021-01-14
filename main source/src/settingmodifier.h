#ifndef SETTINGMODIFIER_H
#define SETTINGMODIFIER_H

#include <QObject>

#include "winRegisteryHandler.h"

class settingModifier : public QObject
{
    Q_OBJECT
public:
    explicit settingModifier(QObject *parent = nullptr);

public slots:
    bool addProgramToContextMenu()
    {
        return mWinRegHndl.addToContextMenu();
    }
signals:

private:
    winRegisteryHandler mWinRegHndl;

};

#endif // SETTINGMODIFIER_H
