import os

env = Environment(ENV = os.environ)
env['WATCOM'] = os.environ['WATCOM']

env.SConscriptChdir(0)
env.SConscript('SConstruct-config',
        exports = ['env'])

env.SConscript(dirs = ['src/loader'],
        exports = ['env'],
        variant_dir = 'build/loader', duplicate = 0)

env.SConscript(dirs = ['src/image'],
        exports = ['env'],
        variant_dir = 'build/image', duplicate = 0)

env = env.Clone(TERMINIT = 'ANSITERM-INIT')
env.SConscript(dirs = ['src/kernel.0'],
        exports = ['env'],
        variant_dir = 'build/ikforth-ansiterm', duplicate = 1)

env = env.Clone(TERMINIT = 'WINCONSOLE-INIT')
env.SConscript(dirs = ['src/kernel.0'],
        exports = ['env'],
        variant_dir = 'build/ikforth-winconsole', duplicate = 1)

env.SConscript('SConscript',
        exports = ['env'])

env.Alias('all', ['build/ikforth-ansiterm/IKForth.img', 'build/ikforth-winconsole/IKForth.img', 'ikforth'])
env.Default('all')
