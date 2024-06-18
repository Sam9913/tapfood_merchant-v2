class Auth {
	late final int merchantId;
	late final String name;
	late final String contactNumber;
	late final String email;
	late int operationStatus;
	late final String? image;
	late final bool acceptOrder;

	Auth(
			{this.image,
				required this.name,
				required this.merchantId,
				required this.contactNumber,
				required this.email,
				required this.operationStatus,
				required this.acceptOrder});

	factory Auth.fromJson(Map<String, dynamic> json) {
		return Auth(
			merchantId: json['id'],
			name: json['name'],
			contactNumber: json['contact_number'],
			operationStatus: json['operation_status'],
			email: json['email'],
			image: json['image'],
			acceptOrder: json['auto_accept_order'] == 1 ? true : false,
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['id'] = merchantId;
		data['name'] = name;
		data['contact_number'] = contactNumber;
		data['operation_status'] = operationStatus;
		data['email'] = email;
		data['image'] = image;
		data['auto_accept_order'] = acceptOrder;
		return data;
	}
}
