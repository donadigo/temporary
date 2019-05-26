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
    'src/CanvasView.vala',
    'src/HeaderMenuButton.vala',
    'src/Document.vala',
    'src/Types.vala',
    'src/AsyncJob.vala',
    'src/EffectBackend.vala',
    'src/Colorspace.vala',
    'src/Image.vala',
    'src/LayerActor.vala',
    'src/Layers/LayerStack.vala',
    'src/Layers/LayerStackItem.vala',
    'src/Layers/Layer.vala',
    'src/Layers/ImageLayer.vala',
    'src/BlendingShader.vala',
    'src/ImageGraph.vala',
    'src/RenderPipeline.vala',
    'src/FileReader.vala',
    'src/PngFileReader.vala',
    'src/NewDocumentDialog.vala',
    gegl_fixes_files,
    dependencies: [
        dependency('glib-2.0'),
        dependency('gee-0.8'),
        dependency('gtk+-3.0'),
        dependency('clutter-1.0'),
        dependency('clutter-gtk-1.0'),
        dependency('gegl-0.4'),
        dependency('gegl-gtk3-0.1'),
        meson.get_compiler('vala').find_library('gegl-fixes', dirs: join_paths(meson.current_source_dir(), 'gegl-fixes')),
        meson.get_compiler('c').find_library('m', required : false)
    ],
    install: true
)