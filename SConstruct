import os

env = Environment(ENV = os.environ)
env.SConscriptChdir(1)
env['WATCOM'] = os.environ['WATCOM']

env.SConscript(dirs = ['src/loader/win32'], exports = ['env'],
        variant_dir = 'build/loader/win32')
