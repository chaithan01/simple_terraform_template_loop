variable master_instance_count {
  default = "3"
}
variable name1 {
  default = "blah"
}

data "template_file" "masters" {
  template = "${file("${path.module}/masters.tpl")}"
  count = "${var.master_instance_count}"
  vars {
    master = "${count.index}.${var.name1}"
  }
}

data "template_file" "masters_list" {
  template = "${file("${path.module}/masters_list.tpl")}"
  vars {
    output = "${join("", data.template_file.masters.*.rendered)}"
  }
}

resource "local_file" "output" {
  content = "${data.template_file.masters_list.rendered}"
  filename = "${path.module}/output"
}
