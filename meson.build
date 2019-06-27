project('com.github.donadigo.crazy-project', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_h_dir = include_directories('.')

add_project_arguments([
    '--vapidir=' + join_paths(meson.source_root(), 'vapi')], '--pkg', 'cogl-fixes', '--pkg=cogl-2.0',
    '-X', '-DCOGL_ENABLE_EXPERIMENTAL_2_0_API', '-X', '$(pkg-config --libs --cflags cogl-2.0-experimental | sed \'s/ -/ -X -/g\')\'',
    language: 'vala'
)

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()),  language:'c')

posix_dep = meson.get_compiler('vala').find_library('posix')

subdir('data')

gegl_fixes_files = files(
    'gegl-fixes/gegl-fixes.c',
    'gegl-fixes/gegl-fixes.h'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/GlobalWindow.vala',
    'src/MainWindow.vala',
    'src/Core/GlobalKeyState.vala',
    'src/Core/EventBus.vala',
    'src/Core/Document.vala',
    'src/Core/Types.vala',
    'src/Core/AsyncJob.vala',
    'src/Core/EffectBackend.vala',
    'src/Core/Colorspace.vala',
    'src/Core/Image.vala',
    'src/Core/ImageMask.vala',
    'src/Core/Service.vala',
    'src/Core/LayerTransformService.vala',
    'src/Core/Layers/LayerList.vala',
    'src/Core/Layers/LayerStack.vala',
    'src/Core/Layers/LayerStackItem.vala',
    'src/Core/Layers/Layer.vala',
    'src/Core/Layers/ImageLayer.vala',
    'src/Core/BlendingShader.vala',
    'src/Core/ImageGraph.vala',
    'src/Core/Action.vala',
    'src/Core/ToolItem.vala',
    'src/Core/ToolItemGroup.vala',
    'src/Core/ToolCollection.vala',
    'src/Core/Tools/MoveToolItem.vala',
    'src/Core/Tools/RectangleSelectToolItem.vala',
    'src/Core/Tools/FreeSelectToolItem.vala',    
    'src/Core/Tools/AutoSelectToolItem.vala',
    'src/Core/Tools/DrawPathToolItem.vala',
    'src/Core/TransformAction.vala',
    'src/Core/Formats.vala',
    'src/Core/RenderPipeline.vala',
    'src/Core/FileReader.vala',    
    'src/Widgets/HeaderBar.vala',
    'src/Widgets/HighlightOverlay.vala',
    'src/Widgets/WorkspaceView.vala',
    'src/Widgets/MainView.vala',
    'src/Widgets/ToolSettingsBar.vala',
    'src/Canvas/CanvasUtils.vala',
    'src/Canvas/LayerActor.vala',
    'src/Canvas/CanvasView.vala',
    'src/Canvas/TransformActor.vala',
    'src/Canvas/TransformHandleActor.vala',
    'src/Canvas/TransformTriggerActor.vala',
    'src/Widgets/HeaderMenuButton.vala',
    'src/Widgets/NotebookView.vala',
    'src/Widgets/WorkspaceTab.vala',
    'src/Widgets/ToolButton.vala',
    'src/Widgets/LayerListBox.vala',
    'src/Widgets/LayerRow.vala',
    'src/Widgets/MouseAdjustableLabel.vala',
    'src/Widgets/Docks/DockWidget.vala',
    'src/Widgets/Docks/DockWindow.vala',
    'src/Widgets/Docks/DockHandle.vala',
    'src/Widgets/Docks/DockContainer.vala',
    'src/Widgets/Docks/ToolDockWidget.vala',
    'src/Widgets/Docks/LayerDockWidget.vala',
    'src/Widgets/Dialogs/NewDocumentDialog.vala',
    gegl_fixes_files,
    icons_gresource,
    css_gresource,
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