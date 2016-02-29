import os

env = Environment(ENV = os.environ)
env.SConscriptChdir(1)
env['WATCOM'] = os.environ['WATCOM']

env.SConscript('SConstruct-config',
        exports = ['env'])

env.SConscript(dirs = ['src/loader'],
        exports = ['env'],
        variant_dir = 'build/loader', duplicate = 1)

env.SConscript(dirs = ['src/image'],
        exports = ['env'],
        variant_dir = 'build/image', duplicate = 1)

env.Alias('all', ['loader', 'image'])
env.Default('all')
