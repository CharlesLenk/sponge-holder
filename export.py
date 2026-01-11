from scad_export import Folder, Model, export

files=Folder(
    name='scad_export/sponge_holder',
    contents=[
        Model(name='sponge_holder')
    ]
)

export(files)
