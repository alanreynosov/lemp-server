# nginx-cookbook Cookbook

TODO: Install a lemp server, currently works only for ubuntu 16.04.

e.g.
This cookbook will setup a LEMP server ready to lunch.

## Requirements

Ubuntu 16.04
Chef 12

e.g.
### Platforms

- Ubuntu 16.04
- Centos 7 (soon)

### Chef

- Chef 12.0 or later

### Cookbooks

- `nginx-cookbook` - set this cookbook as default, and enjoy your coffee.

## Attributes

TODO: List your cookbook attributes here.

e.g.
### nginx-cookbook::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nginx-cookbook']['nginx_user']</tt></td>
    <td>'www-data'</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### nginx-cookbook::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `nginx-cookbook` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nginx-cookbook]"
  ]
}
```

## Contributing

TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: TODO: List authors

