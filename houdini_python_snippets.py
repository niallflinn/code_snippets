######################################################
# set all child alembic frame expressions to reference top node frame parm:

import hou

topnode = hou.node('/obj/mynode')

children = topnode.allSubChildren() 

for child in children:

    if child.type().name() == 'alembic':
        childframeparm = child.parm( 'frame' )       
        childframeparm.setExpression( 'ch("{}/frame")'.format( topnode.path() ) )

######################################################
# list all external paths referenced in houdini

import hou
import os

#### figure out whether we're dealing with an external path
def isLinuxPath( path ):   

    rootcontents = os.listdir('/')
    rootdirectories = []
    for item in rootcontents:
        if os.path.isdir('/{}'.format(item)):
            rootdirectories.append( '/{}'.format(item) )
    
    for rootdirectory in rootdirectories:
        if path.startswith( rootdirectory ):
            return True                       
    return False    
####   

contexts = ['/obj', '/mat', '/img', '/shop']    # contexts to search in Houdini          
paths = []
strippedpaths = []  # paths with filenames stripped off the end

for context in contexts:    

    for parm in hou.node(context).allParms():
    
        if parm.parmTemplate().type().name() == 'String':
            
            value = parm.evalAsString()
            
            if value.startswith('//'):  # remove double slashes
                value = value[1:]
            
            if value.startswith('/'):
            
                if isLinuxPath( value ):
                    paths.append( value )
                         
for path in paths:
    path.strip()
    tokens = path.split('/')[1:-1]
    strippedpath = ''
    for token in tokens:   
        strippedpath = '{}/{}'.format( strippedpath, token )
    strippedpaths.append( strippedpath )        

strippedpaths = list(set(strippedpaths))

strippedpaths.sort()

for strippedpath in strippedpaths:
 
    print( strippedpath )

######################################################
# write out hipfile dependencies to a file:

import hou
import hou_file_utils

def writeDependenciesToFile():

    dependencies = hou_file_utils.get_file_dependencies()
    filename = '{}/{}_dependencies.txt'.format( hou.expandString('$HIP'), hou.expandString('$HIPNAME') )
    
    filehandle = open( filename, 'a' )
    for item in dependencies['show']:
        filehandle.write( item )
        filehandle.write( '\n' )
    filehandle.close()
    
writeDependenciesToFile()


######################################################
# expression to load every nth frame into a file node, etc

import hou

startframe = hou.pwd().parm('startframe').eval() #1001
endframe = hou.pwd().parm('endframe').eval()     #19296
incr = hou.pwd().parm('incr').eval()             #5

frame = hou.frame()

relframe = frame - startframe

if startframe + relframe < endframe:

    return( startframe+floor(relframe/incr)*incr )
else:
    return( endframe )

######################################################
# export selected nodes with opscript:

import hou

nodes = hou.selectedNodes()

for node in nodes:

    print( node.path() )
    
    path = node.path()
    name = node.name()
    
    hscriptcmd = 'opscript -G -r {} > $TEMP/{}.cmd'.format( path, name )
    
    print( hscriptcmd )
    
    hou.hscript( hscriptcmd )

# import nodes from dir with cmdread:

import hou
import os

path = 'C:/Users/niafli/AppData/Local/Temp/houdini_export'

files = os.listdir( path )

for file in files:
    
    filepath = '{}/{}'.format( path, file )
    print( filepath )

    hscriptcommand = 'cmdread {}'.format( filepath )
    
    hou.hscript( hscriptcommand )

######################################################
# get group name from first upstream node:

node = hou.pwd()

upstream = node.inputs()[0]

group = upstream.parm('groupname').eval()

return( group )
