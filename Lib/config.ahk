#Requires AutoHotkey v2.0
#Include <JSON>

class Config
{
    ;@region metadata
    _meta := {
        filename: "",
        saveOnEdit: false,
    }
    ;@endregion

    ;@region properties

    instanceName := ""
    
    ;@endregion

    static Load(filename, saveOnEdit := false)
    {
        if (not FileExist(filename))
        {
            defaultConfig := Config()
            defaultConfig._meta.filename := filename
            defaultConfig._meta.saveOnEdit := saveOnEdit
            defaultConfig.instanceName := "Default"
            defaultConfig.Save()
            return defaultConfig
        }

        cfg := JSON.parse(FileRead(filename), false, false, Config)
        cfg._meta := {
            filename: filename,
            saveOnEdit: saveOnEdit,
        }
        return cfg
    }

    __Item[name]
    {
        get => this.%name%
        set {
            this.%name% := value
            if (this._saveOnEdit)
            {
                this.Save()
            }
        }
    }

    Save()
    {
        configWriter := FileOpen(this._filename, 'w')
        meta := this._meta
        this.DeleteProp('_meta')
        configWriter.Write(JSON.stringify(this))
        configWriter.Close()
        this._meta := meta
    }

    SetSaveOnEdit(value)
    {
        this._saveOnEdit := value
    }
}
