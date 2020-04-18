# ikforth
import os

Import('env', 'fkernelPath', 'productdict')
senv = env.Clone()

ikforthExec = senv.execname('IKForth-${TSYS}')
ikforthDict = 'IKForth-${TSYS}.img'

senv.Replace(RUN_CMD = '${RUN_LAUNCHER} ./' + ikforthExec)

def run(source, target, env):
    env.Execute('${RUN_CMD}')

def test(source, target, env):
    env.Execute('${RUN_CMD} -f IKForth-test.4th')

def test_stdin(source, target, env):
    env.Execute('echo \'S\" fine!\" TYPE\' | ${RUN_CMD} -f test/stdin-test.4th')

def ansitest(source, target, env):
    env.Execute('${RUN_CMD} -f test/forth2012-test.4th')

def fptest(source, target, env):
    env.Execute('${RUN_CMD} -f test/fp-test.4th')

senv.InstallAs(ikforthDict, productdict)
senv.InstallAs(ikforthExec, fkernelPath)
senv.NoClean([ikforthDict, ikforthExec])

senv.Alias('ikforth', [ikforthExec, ikforthDict])

dist_src = []
dist_src.extend(senv.Glob('#app/**'))
dist_src.extend(senv.Glob('#blocks/**'))
dist_src.extend(senv.Glob('#lib/**'))
dist_src.extend(senv.Glob('#docs/*.md'))
dist_src.extend(senv.Glob('*.md'))
dist_src.extend(senv.Glob('LICENSE'))
dist_src.extend(senv.Glob('IKForth-*.elf'))
dist_src.extend(senv.Glob('IKForth-*.exe'))
dist_src.extend(senv.Glob('IKForth-*.img'))
dist_src.extend(senv.Glob('IKForth*.4th'))
senv.Replace(TARFLAGS = '-c -z')
senv.Replace(TARSUFFIX = '.tar.gz')
dist_tar = senv.Tar('#build/${DIST_FILE_NAME}', dist_src)
dist_zip = senv.Zip('#build/${DIST_FILE_NAME}', dist_src)

senv.Alias('dist', [dist_tar, dist_zip])

senv.Clean("dist", [
    ".sconsign.dblite",
    ".sconf_temp",
    "config.log",
])

senv.Alias('all', ['ikforth'])
senv.Clean('all', ['#build'])

senv.Alias('run', [], run)
senv.Alias('test', [], test)
senv.Alias('test-stdin', [], test_stdin)
senv.Alias('ansitest', [], ansitest)
senv.Alias('fptest', [], fptest)

senv.Depends('run',        ['ikforth'])
senv.Depends('test',       ['ikforth'])
senv.Depends('test-stdin', ['ikforth'])
senv.Depends('ansitest',   ['ikforth'])
senv.Depends('fptest',     ['ikforth'])

senv.AlwaysBuild('run', 'test', 'test-stdin', 'ansitest', 'fptest', 'dist')
