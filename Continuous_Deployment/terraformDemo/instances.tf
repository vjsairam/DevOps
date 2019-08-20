resource "aws_instance" "webservers" {
	count = "${var.instance_count}"
        ami = "${var.webservers_ami}"
	instance_type = "${var.instance_type}"
	security_groups = ["${aws_security_group.webservers.id}"]
	subnet_id = "${element(aws_subnet.public.*.id,count.index)}"
	user_data = "${file("userdata.sh")}"

	tags = {
	  Name = "WebServer"
	}
}
