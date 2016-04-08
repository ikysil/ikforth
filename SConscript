# ikforth

Import('env', 'fkernelPath')
senv = env.Clone()

ikforthExec = senv.execname('IKForth');
ikforthDict = 'IKForth.img'

senv.Replace(RUN_CMD = '${RUN_LAUNCHER} ./' + ikforthExec)

def run(source, target, env):
    env.Execute('${RUN_CMD}')

def test(source, target, env):
    env.Execute('${RUN_CMD} \'S\" IKForth-test.4th\" INCLUDED\'')

def test_stdin(source, target, env):
    env.Execute('echo \'S\" fine!\" TYPE\' | ${RUN_CMD} \'S\" test/stdin-test.4th\" INCLUDED\'')

def ansitest(source, target, env):
    env.Execute('${RUN_CMD} \'S\" test/forth2012-test.4th\" INCLUDED\'')

source_dir = '#build/ikforth-$TERMINIT/'

senv.Command(ikforthDict, source_dir + ikforthDict, Copy('$TARGET', '$SOURCE'))
senv.Command(ikforthExec, fkernelPath, Copy('$TARGET', '$SOURCE'))

senv.Alias('ikforth', [ikforthExec, ikforthDict])

senv.Alias('all', 'ikforth')
senv.Depends('all', [source_dir + ikforthDict])
senv.Clean('all', ['#build', 'IKForth', 'IKForth.exe'])

senv.Alias('run', [], run)
senv.Alias('test', [], test)
senv.Alias('test-stdin', [], test_stdin)
senv.Alias('ansitest', [], ansitest)

senv.Depends('run',        ['all'])
senv.Depends('test',       ['all'])
senv.Depends('test-stdin', ['all'])
senv.Depends('ansitest',   ['all'])

senv.AlwaysBuild('run', 'test', 'test-stdin', 'ansitest')
