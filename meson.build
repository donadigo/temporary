project('com.github.donadigo.crazy-project', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_h_dir = include_directories('.')

add_project_arguments([
    '--vapidir=' + join_paths(meson.source_root(), 'vapi')], '--pkg', 'cogl-fixes',
    language: 'vala'
)

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()),  language:'c')

posix_dep = meson.get_compiler('vala').find_library('posix')

gegl_fixes_files = files(
    'gegl-fixes/gegl-fixes.c',
    'gegl-fixes/gegl-fixes.h'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/HeaderBar.vala',
    'src/WorkspaceView.vala',
    'src/MainView.vala',
    'src/CanvasView.vala',
    'src/HeaderMenuButton.vala',
    'src/LayerActor.vala',
    'src/NotebookView.vala',
    'src/WorkspaceTab.vala',
    'src/Core/Document.vala',
    'src/Core/Types.vala',
    'src/Core/AsyncJob.vala',
    'src/Core/EffectBackend.vala',
    'src/Core/Colorspace.vala',
    'src/Core/Image.vala',
    'src/Core/Layers/LayerStack.vala',
    'src/Core/Layers/LayerStackItem.vala',
    'src/Core/Layers/Layer.vala',
    'src/Core/Layers/ImageLayer.vala',
    'src/Core/BlendingShader.vala',
    'src/Core/ImageGraph.vala',
    'src/Core/RenderPipeline.vala',
    'src/Core/FileReader.vala',
    'src/Core/PngFileReader.vala',
    'src/NewDocumentDialog.vala',
    gegl_fixes_files,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gee-0.8'),
        dependency('gtk+-3.0'),
        dependency('clutter-1.0'),
        dependency('clutter-gtk-1.0'),
        dependency('gegl-0.4'),
        dependency('granite'),
        dependency('libdazzle-1.0'),
        meson.get_compiler('vala').find_library('posix'),
        meson.get_compiler('vala').find_library('gegl-fixes', dirs: join_paths(meson.current_source_dir(), 'gegl-fixes')),
        meson.get_compiler('c').find_library('m', required : false)
    ],
    install: true
)