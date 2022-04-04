output "private-key-of-keypair" {
    value = tls_private_key.this.private_key_pem
    sensitive = true
}