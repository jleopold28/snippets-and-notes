#!/usr/bin/python
import hashlib
from ansible.module_utils.basic import AnsibleModule


def main():

    module = AnsibleModule(
        argument_spec=dict(
           string=dict(required=True)
        ),
    )

    string = module.params['string']

    md5 = hashlib.md5(string).hexdigest()
    sha1 = hashlib.sha1(string).hexdigest()
    sha256 = hashlib.sha256(string).hexdigest()
    sha512 = hashlib.sha512(string).hexdigest()

    module.exit_json(changed=False, original_string=string, md5_hash=md5, sha1_hash=sha1, sha256=sha256, sha512=sha512)


if __name__ == '__main__':
    main()
