#Requires AutoHotkey v2.0
#Include <JSON>

class Config
{
    ;@region metadata
    _meta := {
        filename: "",
    }
    ;@endregion

    ;@region properties

    instanceName := ""
    
    ;@endregion

    static Load(filename)
    {
        if (not FileExist(filename))
        {
            defaultConfig := Config()
            defaultConfig._meta.filename := filename
            defaultConfig.instanceName := "Default"
            defaultConfig.Save()
            return defaultConfig
        }

        cfg := JSON.parse(FileRead(filename), false, false, Config)
        cfg._meta := {
            filename: filename,
        }
        return cfg
    }

    __Item[name]
    {
        get => this.%name%
        set => this.%name% := value
    }

    Save()
    {
        configWriter := FileOpen(this._meta.filename, 'w')
        meta := this._meta
        this.DeleteProp('_meta')
        configWriter.Write(JSON.stringify(this))
        configWriter.Close()
        this._meta := meta
    }
}
