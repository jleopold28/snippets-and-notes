// vars/goss.groovy
def call(body) {
  // evaluate the body block, and collect configuration into the object
  def config = [:]
  body.resolveStrategy = Closure.DELEGATE_FIRST
  body.delegate = config
  body()

  // error checking
  if ((config.gossfile != null) && (!fileExists(config.gossfile))) {
    throw "Gossfile ${config.gossfile} does not exist!"
  }

  // do the thing
  try {
    if (config.gossfile != null) {
      sh "goss validate"
    }
    else {
      sh "goss -g ${config.gossfile} validate"
    }
  }
  catch(error) {
    echo 'Failure using goss:'
    throw error
  }
}

// goss {
//   gossfile = 'goss.yaml' // optional
// }
