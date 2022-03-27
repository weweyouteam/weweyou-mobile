
import 'package:weweyou/utils/constants.dart';

class SignupModel {
  SignupModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final UserModel data;

  SignupModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = UserModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.avatar,
    required this.roleId,
    required this.apitoken,
  });
  late final int id;
  late final String email;
  late final String name;
  late final String address;
  late final String avatar;
  late final String roleId;
  late final String apitoken;

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    email = json['email'];
    address = json['address'];
    name = json['name'];
    avatar = json['avatar']??imagePath;
    roleId = json['roleId'];
    apitoken = json['apitoken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['name'] = name;
    _data['address'] = address;
    _data['avatar'] = avatar;
    _data['role_id'] = roleId;
    _data['apitoken'] = apitoken;
    return _data;
  }
}
class UserProfile {
  UserProfile({
    required this.code,
    required this.message,
    required this.profile,
    required this.event,
    required this.group,
    required this.following,
  });
  late final String code;
  late final String message;
  late final Profile profile;
  late final int event;
  late final int group;
  late final int following;

  UserProfile.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    profile = Profile.fromJson(json['profile']);
    event = json['event'];
    group = json['group'];
    following = json['following'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['profile'] = profile.toJson();
    _data['event'] = event;
    _data['group'] = group;
    _data['following'] = following;
    return _data;
  }
}

class Profile {
  Profile({
    required this.id,
    required this.name,
    this.lastName,
    required this.email,
    required this.avatar,
  });
  late final int id;
  late final String name;
  late final Null lastName;
  late final String email;
  late final String avatar;

  Profile.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    lastName = null;
    email = json['email'];
    avatar = json['avatar']??imagePath;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['avatar'] = avatar;
    return _data;
  }
}

class UserInformationModel {
  UserInformationModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final UserInformation data;

  UserInformationModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = UserInformation.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class UserInformation {
  UserInformation({
    required this.id,
    required this.name,
    this.lastName,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
    required this.settings,
    required this.roleId,
    this.organisation,
    this.bankName,
    this.bankCode,
    this.bankBranchName,
    this.bankBranchCode,
    this.bankAccountNumber,
    this.bankAccountName,
    this.bankAccountPhone,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.phone,
    required this.status,
    required this.otp,
    required this.otpConfirmation,
    required this.apitoken,
    required this.fbId,
    required this.googleId,
    required this.appleId,
    this.following,
  });
  late final int id;
  late final String name;
  late final Null lastName;
  late final String email;
  late final Null emailVerifiedAt;
  late final String createdAt;
  late final String updatedAt;
  late final String avatar;
  late final List<dynamic> settings;
  late final int roleId;
  late final Null organisation;
  late final Null bankName;
  late final Null bankCode;
  late final Null bankBranchName;
  late final Null bankBranchCode;
  late final Null bankAccountNumber;
  late final Null bankAccountName;
  late final Null bankAccountPhone;
  late final String address;
  late final String city;
  late final String latitude;
  late final String longitude;
  late final Null phone;
  late final int status;
  late final int otp;
  late final int otpConfirmation;
  late final String apitoken;
  late final String fbId;
  late final String googleId;
  late final String appleId;
  late final Null following;

  UserInformation.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    lastName = null;
    email = json['email'];
    emailVerifiedAt = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avatar = json['avatar']??imagePath;
    settings = List.castFrom<dynamic, dynamic>(json['settings']);
    roleId = json['role_id'];
    organisation = null;
    bankName = null;
    bankCode = null;
    bankBranchName = null;
    bankBranchCode = null;
    bankAccountNumber = null;
    bankAccountName = null;
    bankAccountPhone = null;
    address = json['address'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = null;
    status = json['status'];
    otp = json['otp'];
    otpConfirmation = json['otp_confirmation'];
    apitoken = json['apitoken'];
    fbId = json['fb_id'];
    googleId = json['google_id'];
    appleId = json['apple_id'];
    following = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['avatar'] = avatar;
    _data['settings'] = settings;
    _data['role_id'] = roleId;
    _data['organisation'] = organisation;
    _data['bank_name'] = bankName;
    _data['bank_code'] = bankCode;
    _data['bank_branch_name'] = bankBranchName;
    _data['bank_branch_code'] = bankBranchCode;
    _data['bank_account_number'] = bankAccountNumber;
    _data['bank_account_name'] = bankAccountName;
    _data['bank_account_phone'] = bankAccountPhone;
    _data['address'] = address;
    _data['city'] = city;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['phone'] = phone;
    _data['status'] = status;
    _data['otp'] = otp;
    _data['otp_confirmation'] = otpConfirmation;
    _data['apitoken'] = apitoken;
    _data['fb_id'] = fbId;
    _data['google_id'] = googleId;
    _data['apple_id'] = appleId;
    _data['following'] = following;
    return _data;
  }
}
