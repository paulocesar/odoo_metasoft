CREATE TABLE [WallhackTemplate] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [name] VARCHAR(250) NOT NULL,
    [template] TEXT NOT NULL,

    CONSTRAINT [PK_WallhackTemplate] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [UQ_WallhackTemplate_name] UNIQUE(name)
)

GO
