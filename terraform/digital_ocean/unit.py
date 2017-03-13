""" suite of terraform unit tests """

import os
import unittest
import terraform_validate


class TestDigitalOcean(unittest.TestCase):
    """ test digital ocean terraform configuration """

    def setUp(self):
        """ setup paths for testing """
        self.path = os.path.join(os.path.dirname(
            os.path.realpath(__file__)), "../digital_ocean")
        self.validator = terraform_validate.Validator(self.path)

    def test_digitalocean_droplet(self):
        """ test droplet """
        self.validator.error_if_property_missing()
        droplet = self.validator.resources('digitalocean_droplet')
        droplet.property('image').should_equal('ubuntu-16-04-x64')
        droplet.property('region').should_equal('nyc1')
        droplet.property('size').should_equal('512mb')
        droplet.property('ssh_keys').should_equal(
            ['${digitalocean_ssh_key.key.id}'])
        droplet.property('tags').should_equal(["${digitalocean_tag.tag.name}"])
        droplet.property('volume_ids').should_equal(
            ['${digitalocean_volume.volume.id}'])

    def test_digitalocean_floating_ip(self):
        """ test floating ip """
        self.validator.error_if_property_missing()
        float_ip = self.validator.resources('digitalocean_floating_ip')
        float_ip.property('droplet_id').should_equal(
            '${digitalocean_droplet.droplet.id}')
        float_ip.property('region').should_equal(
            '${digitalocean_droplet.droplet.region}')

    def test_digitalocean_domain(self):
        """ test domain """
        self.validator.error_if_property_missing()
        domain = self.validator.resources('digitalocean_domain')
        domain.property('name').should_equal('sealand.shadow-soft.com')
        domain.property('ip_address').should_equal(
            '${digitalocean_droplet.droplet.ipv4_address}')

    def test_digitalocean_volume(self):
        """ test volume """
        self.validator.error_if_property_missing()
        volume = self.validator.resources('digitalocean_volume')
        volume.property('region').should_equal('nyc1')
        volume.property('name').should_equal('a-volume')
        volume.property('size').should_equal(100)
        volume.property('description').should_equal('this is a volume')


if __name__ == '__main__':
    SUITE = unittest.TestLoader().loadTestsFromTestCase(TestDigitalOcean)
    unittest.TextTestRunner(verbosity=0).run(SUITE)
