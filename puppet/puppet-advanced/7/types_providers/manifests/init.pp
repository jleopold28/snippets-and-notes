class types_providers {
  message { 'hi': }
  message { 'caps': capitalize => true }
  message { 'LOW': lowercase => true }
  message { 'olleh': reverse => true }
  message { 'all mixed up':
    capitalize => true,
    reverse    => true,
  }
}
