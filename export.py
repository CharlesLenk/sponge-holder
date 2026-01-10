from scad_export.export import export
from scad_export.exportable import Folder, Model

files=Folder(
    name='scad_export/sponge_holder',
    contents=[
        Model(name='sponge_holder')
    ]
)

export(files)
