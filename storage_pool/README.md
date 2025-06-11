# libvirt storage_pool

A Terraform module to create and manage a Libvirt storage pools for KVM/QEMU virtualization using the [dmacvicar/libvirt](https://registry.terraform.io/providers/dmacvicar/libvirt/latest) provider.

## Requirements

<table><thead>
  <tr>
    <th>Name</th>
    <th>Version</th>
  </tr></thead>
<tbody>
  <tr>
    <td>Terraform</td>
    <td>>= 1.0</td>
  </tr>
  <tr>
    <td>libvirt</td>
    <td>>= 0.8.3</td>
  </tr>
</tbody>
</table>

## Providers

<table><thead>
  <tr>
    <th>Name</th>
    <th>Version</th>
  </tr></thead>
<tbody>
  <tr>
    <td>dmacvicar/libvirt</td>
    <td>>= 0.8.3</td>
  </tr>
</tbody>
</table>

## Usage

```hcl
module "default" {
  source = "git::https://github.com/h3d3m/terraform-libvirt-modules.git//modules/storage_pool"

  name = "default"
  type = "dir"
  path = "/var/lib/machines/default"
}
```


## Inputs

<table><thead>
  <tr>
    <th>Name</th>
    <th>Description</th>
    <th>Type</th>
    <th>Default</th>
    <th>Required</th>
  </tr></thead>
<tbody>
  <tr>
    <td>name</td>
    <td>A unique name for the resource</td>
    <td>string</td>
    <td></td>
    <td>yes</td>
  </tr>
  <tr>
    <td>type</td>
    <td>The type of the pool ("dir" and "logical" are supported)</td>
    <td>string</td>
    <td></td>
    <td>yes</td>
  </tr>
  <tr>
    <td>path</td>
    <td>The path of the pool</td>
    <td>string</td>
    <td>/var/lib/machines/</td>
    <td>no</td>
  </tr>
</tbody>
</table>

## Outputs

<table><thead>
  <tr>
    <th>Name</th>
    <th>Description</th>
  </tr></thead>
<tbody>
  <tr>
    <td>id</td>
    <td>ID of the libvirt storage pool</td>
  </tr>
</tbody>
</table>
