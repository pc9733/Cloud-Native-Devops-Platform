# Building Packer AMI

1. Log in to LastPass:
    ```
    lpass login piyush7583@gmail.com
    lpass status
    ```

2. Export the Datadog API key:
    ```
    export DD_API_KEY="$(lpass show --password 'Datadog-api')"
    ```

3. Build the Packer image:
    ```
    packer build packer-ami-docker.json
    ```