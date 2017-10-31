// vars/packer.groovy
def call(body) {
  // evaluate the body block, and collect configuration into the object
  def config = [:]
  body.resolveStrategy = Closure.DELEGATE_FIRST
  body.delegate = config
  body()

  // error checking
  if (config.action == null) {
    throw 'Packer action must be specified!'
  }
  if (config.template == null) {
    throw 'Packer template must be provided!'
  }
  if (!fileExists(config.template)) {
    throw "Packer template ${config.template} does not exist!"
  }

  // do the thing
  try {
    sh "packer ${config.action} ${config.template}"
  }
  catch(error) {
    echo 'Failure using packer:'
    throw error
  }
}

// packer {
//   action = 'build',
//   template = 'packer.json'
// }
