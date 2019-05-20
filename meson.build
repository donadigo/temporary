project('com.github.donadigo.crazy-project', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_h_dir = include_directories('.')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

posix_dep = meson.get_compiler('vala').find_library('posix')

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/HeaderBar.vala',
    'src/WorkspaceView.vala',
    'src/CanvasView.vala',
    'src/HeaderMenuButton.vala',
    'src/Layer.vala',
    'src/Document.vala',
    'src/Types.vala',
    'src/AsyncJob.vala',
    'src/EffectBackend.vala',
    'src/Colorspace.vala',
    'src/Image.vala',
    'src/ImageLayer.vala',
    'src/LayerActor.vala',
    'src/ReactiveActor.vala',
    'src/LayerStack.vala',
    'src/FileReader.vala',
    'src/PngFileReader.vala',
    'src/NewDocumentDialog.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('gegl-0.3'),
        dependency('clutter-1.0'),
        dependency('clutter-gtk-1.0'),

        meson.get_compiler('c').find_library('m', required : false)
    ],
    install: true
)