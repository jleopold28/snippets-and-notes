// vars/terraform.groovy
def call(body) {
  // evaluate the body block, and collect configuration into the object
  def config = [:]
  body.resolveStrategy = Closure.DELEGATE_FIRST
  body.delegate = config
  body()

  // error checking
  if (config.action == null) {
    throw 'Terraform action must be specified!'
  }
  if (config.config == null) {
    throw 'Terraform config must be provided!'
  }
  if (!fileExists(config.config)) {
    throw "Terraform config ${config.config} does not exist!"
  }

  // do the thing
  try {
    sh "terraform ${config.action} ${config.config}"
  }
  catch(error) {
    echo 'Failure using terraform:'
    throw error
  }
}

// terraform {
//   action = 'apply',
//   template = 'main.tf'
// }
