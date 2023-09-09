import 'dart:io';

import 'package:Molhem/data/datasource/remote/users_data/users_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/firestore_create_user_error.dart';
import '../../../models/user_information.dart';

class FirestoreUsersRemoteDataSource implements UsersRemoteDataSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<FirestoreCreateUserError, bool>> addUser(
      UserInformation userInformation) async {
    try {
      await firestore.collection('users').add(userInformation.toFirestore());
      return const Right(true);
    } catch (firestoreError) {
      return Left(FirestoreCreateUserError(firestoreError.toString()));
    }
  }

  @override
  Future<void> deleteUser(String uid) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<UserInformation> getUserInformation(String uid) async {
    var users = (await firestore.collection('users').get())
        .docs
        .where((element) => element['uid'] == uid)
        .toList();

    if (users.isEmpty) {
      return UserInformation(
          username: 'john doe',
          phone: '+0123456789',
          email: 'johndoe@example.com',
          childToken: 'none',
          parentToken: 'none',
          age: 20);
    } else {
      return UserInformation.fromFirestore(users.first);
    }
  }

  @override
  Future<void> updateUser(String uid, UserInformation userInformation) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<void> uploadUserImage(File file) {
    // TODO: implement uploadUserImage
    throw UnimplementedError();
  }

  @override
  Future<void> changeUserLoggedType(String uid, String newRole) async {
    try {
      QuerySnapshot data = await firestore.collection('users').get();
      String id = data.docs.where((element) => element['uid'] == uid).first.id;
      await firestore.collection('users').doc(id).update({'loggedAs': newRole});
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String?> getUserLoggedType(String uid) async {
    QuerySnapshot data = await firestore.collection('users').get();
    QueryDocumentSnapshot user =
        data.docs.where((element) => element['uid'] == uid).first;
    return user['loggedAs'];
  }

  @override
  Future<void> changeUserLoggedTypeByEmail(String email, String role) async {
    try {
      QuerySnapshot data = await firestore.collection('users').get();
      String id =
          data.docs.where((element) => element['email'] == email).first.id;
      await firestore.collection('users').doc(id).update({'loggedAs': role});
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> getUserReference(String uid) async {
    QuerySnapshot data = await firestore.collection('users').get();
    QueryDocumentSnapshot user =
        data.docs.where((element) => element['uid'] == uid).first;
    return user.id;
  }

  @override
  Future<void> initializeNewUserData(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String ref = (await firestore.collection('users').get())
        .docs
        .where((element) => element['uid'] == uid)
        .first
        .id;

        List<Map<String, dynamic>> feelings = [
      {
      'image':
      "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(25).png?alt=media&token=9491fff1-ffb9-47c3-8b49-5397e9286e64&_gl=1*4bq5qy*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTg5MzgyNy4xMS4xLjE2ODU4OTQ0NjMuMC4wLjA.",
      'content': "anxious",
      'content-ar': "عصبية",
      'degree': 'bad'
      },
      {
      'image':
      "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A39%3A46.294723.jpg?alt=media&token=6be7bd74-3292-4c24-8ab7-28d8ff7a25b5",
        'content': "Hopeful",
        'content-ar': "متفائل",
        'degree': 'good'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A40%3A20.008524.jpg?alt=media&token=57b5d7f8-67b0-464f-8811-855dc0db4b68",
        'content': "confidence",
        'content-ar': "واثق",
        'degree': 'good'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A38%3A12.350568.jpg?alt=media&token=cf381ce4-415d-4461-8eda-7286c8e92767",
        'content': "scared",
        'content-ar': "مرتعب",
        'degree': 'bad'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A33%3A40.459697.jpg?alt=media&token=0b22fe83-dc6b-4190-a909-3226b3157ad2",
        'content': "worried",
        'content-ar': "قلقان",
        'degree': 'bad'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(24).png?alt=media&token=93d2d8b4-0d35-4457-9782-e9a823ff78de&_gl=1*1el4sfq*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTg5MzgyNy4xMS4xLjE2ODU4OTQ0OTguMC4wLjA.",
        'content': "sad",
        'content-ar': "حزين",
        'degree': 'bad'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A39%3A08.091741.jpg?alt=media&token=2db5b04e-8920-4d40-8dd0-2e7e0728d336",
        'content': "confused",
        'content-ar': "مرتبك",
        'degree': 'bad'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A25%3A16.249054.jpg?alt=media&token=67ec2bdc-d07e-43d1-971e-bbe6ef6bcf7b",
        'content': "depressed",
        'content-ar': "مكتئب",
        'degree': 'bad'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/feelings%2F2023-05-19%2013%3A37%3A29.425047.jpg?alt=media&token=9f19ca99-9a23-4549-b617-9b6edf7740c0",
        'content': "laughing",
        'content-ar': "يضحك",
        'degree': 'good'
      },
      {
        'image':
        "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(27).png?alt=media&token=3a1da622-ba23-45cf-8da1-c3fdcf843093&_gl=1*3oon0b*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTg5MzgyNy4xMS4xLjE2ODU4OTQzMDkuMC4wLjA.",
        'content': "angry",
        'content-ar': "غاضب",
        'degree': 'bad'
      },
      {
        'image':
        "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(26).png?alt=media&token=a8ad0646-dfba-4368-8345-082c11b3b770&_gl=1*18ow58v*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTg5MzgyNy4xMS4xLjE2ODU4OTQ0MzEuMC4wLjA.",
        'content': "happy",
        'content-ar': "سعيد",
        'degree': 'good'
      },
      {
        'image':
            "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(23).png?alt=media&token=a90aa62b-a9ba-434d-bb18-6b30f109fa35&_gl=1*29m9n*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTg5MzgyNy4xMS4xLjE2ODU4OTQ1MjIuMC4wLjA.",
        'content': "crying",
        'content-ar': "أبكي",
        'degree': 'bad'
      },
    ];
    for (Map<String, dynamic> data in feelings) {
      await firestore
          .collection('users')
          .doc(ref)
          .collection('child-feelings')
          .add(data);
    }

    List<Map<String, dynamic>> wants = [
      {
        'content': 'Cat',
        'content-ar': 'قطة',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A21%3A40.593288.jpg?alt=media&token=92348a91-468f-42c0-934d-79db1191a922'
      },
      {
        'content': 'Sleep',
        'content-ar': 'النوم',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A20%3A47.187016.jpg?alt=media&token=2147fdcd-f48c-4c21-ba19-33337277b8af'
      },
      {
        'content': 'Apple',
        'content-ar': 'تفاحة',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-16%2001%3A49%3A40.290802.jpg?alt=media&token=cf506fa8-409c-4926-8fa7-57128c05cb8c'
      },
      {
        'content': 'Biscuits',
        'content-ar': 'بسكويت',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A23%3A09.584197.jpg?alt=media&token=886b17e3-5f37-41ad-a30f-b449a31b8696'
      },
      {
        'content': 'Hug',
        'content-ar': 'عناق',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A18%3A38.347008.jpg?alt=media&token=1536c445-fbcd-42e6-bd27-be474ea431b7'
      },
      {
        'content': 'Care',
        'content-ar': 'اهتمام',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A21%3A07.649497.jpg?alt=media&token=8e2b3040-2999-4116-bc51-64094fd6f105'
      },
      {
        'content': 'Dog',
        'content-ar': 'كلب',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A22%3A11.205625.jpg?alt=media&token=623ae7fc-ab7a-451d-9fc1-ee8414fb5293'
      },
      {
        'content': 'Love',
        'content-ar': 'حب',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A19%3A09.961379.jpg?alt=media&token=34dac6dc-9ae3-49c9-9ff7-f970eba9f518'
      },
      {
        'content': 'Ball',
        'content-ar': 'كرة',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A22%3A32.477842.jpg?alt=media&token=fc87439b-0114-4b17-9145-215cac143c46'
      },
      {
        'content': 'Cookies',
        'content-ar': 'كوكيز',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A23%3A26.903061.jpg?alt=media&token=5ab8ed8d-2b05-490d-b91f-723706169ca4'
      },
      {
        'content': 'Banana',
        'content-ar': 'موز',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-16%2001%3A50%3A12.106958.jpg?alt=media&token=a686f9d0-1b59-4852-b1d4-0d7d75b79cde'
      },
      {
        'content': 'Tv',
        'content-ar': 'تلفاز',
        'degree': 'good',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-19%2013%3A24%3A10.211320.jpg?alt=media&token=6e02aa59-abcf-402c-88a8-c18de4a23b4b'
      },
    ];
    for (Map<String, dynamic> data in wants) {
      await firestore
          .collection('users')
          .doc(ref)
          .collection('child-want')
          .add(data);
    }

    List<Map<String, dynamic>> music = [
      {
        'name': 'Calm Music',
        'name-ar': 'موسيقي هادئة',
        'source': 'https://www.youtube.com/watch?v=-9rKDBunT4Y&&t=158s'
      },
      {
        'name': 'Baby Shark',
        'name-ar': 'بيبي شارك',
        'source': 'https://www.youtube.com/watch?v=XqZsoesa55w'
      },
      {
        'name': 'Twinkle Twinkle Little Star',
        'name-ar': 'وميض نجمة صغيرة',
        'source': 'https://www.youtube.com/watch?v=yCjJyiqpAuU'
      },{
        'name': 'Mickey',
        'name-ar': 'ميكي',
        'source': 'https://www.youtube.com/watch?v=psLd-dy_b3Q&pp=ygUo2YXZiNiz2YrZgtmKINmF2YbYp9iz2KjYqSDZhNmE2KfYt9mB2KfZhA%3D%3D'
      },{
        'name': "If You're Happy and You Know It",
        'name-ar': 'لو انك سعيد و تعرف',
        'source': 'https://www.youtube.com/watch?v=l4WNrvVjiTw&pp=ygUfSWYgWW91J3JlIEhhcHB5IGFuZCBZb3UgS25vdyBJdA%3D%3D'
      },{
        'name': 'Old MacDonald Had a Farm',
        'name-ar': 'مكدونالدز العجوز',
        'source': 'https://www.youtube.com/watch?v=Wm4R8d0d8kU&pp=ygUYT2xkIE1hY0RvbmFsZCBIYWQgYSBGYXJt'
      },
    ];
    for (Map<String, dynamic> data in music) {
      await firestore
          .collection('users')
          .doc(ref)
          .collection('child-music')
          .add(data);
    }

    List<Map<String, dynamic>> stories = [
      {
        'author': 'GPT',
        'content-ar':
            "ذات مرة ، كان هناك صبي يدعى أوليفر لديه طريقة خاصة لتجربة العالم. أخذه والداه إلى حديقة خاصة مصممة خصيصًا للأطفال مثله. في الحديقة ، كان بإمكان أوليفر لمس العشب الناعم ، والاستماع إلى الأصوات اللطيفة ، والشعور بالماء البارد. كان مكانًا ساحرًا يشعر فيه بالهدوء والسعادة. أحب والدا أوليفر رؤية مدى استمتاعه بالحديقة ، لذا فقد أنشأوا مساحة خاصة في المنزل ليخوض مغامرات حسية كل يوم.",
        'content':
            "Once upon a time, there was a boy named Oliver who had a special way of experiencing the world. His parents took him to a special garden designed just for children like him. In the garden, Oliver could touch soft grass, listen to gentle sounds, and feel cool water. It was a magical place where he felt calm and happy. Oliver's parents loved seeing how much he enjoyed the garden, so they created a special space at home for him to have sensory adventures every day.",
        'title': 'The Sensory Adventure',
        'title-ar': 'المغامرة الحسية',
        'image':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/stories%2F2023-05-16%2007%3A48%3A12.672169.jpg?alt=media&token=f52ea93f-af03-4133-8b24-3e83cdfd4191'
      },
      {
        "author": "GPT",
        "content-ar": "في قديم الزمان، عاشت فتاة صغيرة تدعى سارة. كانت سارة طفلة خيالية ومغامرة، تحب استكشاف العالم من حولها. في يوم من الأيام، اكتشفت سارة بوابة سرية في حديقة منزلها. عندما عبرت البوابة، وجدت نفسها في عالم آخر مليء بالجمال والسحر. كانت الأشجار هناك تتحدث والأزهار تضيء بألوان زاهية. قابلت سارة أصدقاء جدد، مثل الأقزام الودودة والحيوانات الحديثة. استمتعت سارة باللعب معهم واستكشاف المكان الجديد بشغف. لكن عندما حان الوقت للعودة، كانت سارة حزينة. وعدت نفسها بزيارة هذا العالم السحري مرة أخرى. وعندما عادت إلى منزلها، أخبرت والديها عن مغامرتها الرائعة وأنشأوا مساحة خاصة في حديقة المنزل لتصبح بوابة إلى العوالم السرية لسارة.",
        "content": "Once upon a time, there lived a young girl named Sarah. Sarah was an imaginative and adventurous child who loved exploring the world around her. One day, Sarah discovered a secret gateway in the garden of her house. When she stepped through the gateway, she found herself in another world full of beauty and magic. The trees there spoke, and the flowers glowed in vibrant colors. Sarah met new friends like friendly dwarves and talking animals. She enjoyed playing with them and eagerly exploring the new place. But when it was time to return, Sarah felt sad. She promised herself to visit this magical world again. Upon returning home, she told her parents about her wonderful adventure, and they created a special space in the garden of their house to become a gateway to Sarah's secret worlds.",
        "title": "Sarah's Secret Worlds",
        "title-ar": "عوالم سارة السرية",
        "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/stories%2F2023-05-16%2007%3A48%3A12.672169.jpg?alt=media&token=f52ea93f-af03-4133-8b24-3e83cdfd4191"
      },
      {
        "author": "GPT",
        "content-ar": "في يوم من الأيام، وُلدت فتاة صغيرة تُدعى ليلى. كانت ليلى فتاة مبدعة وفضولية، تحب استكشاف العالم واكتشاف أشياء جديدة. في حديقة المنزل، اكتشفت ليلى مخبأًا سريًا خلف شجيرة صغيرة. عندما فتحت المخبأ، اكتشفت عالمًا مدهشًا يمتلئ بالألوان والأشكال المبهجة. كانت الأشجار تتحدث والحيوانات تتواصل بلغة سحرية. قابلت ليلى أصدقاء جدد، مثل الأميرات العفريتات والحيوانات الذكية. استمتعت ليلى باللعب والرقص والغناء معهم، وتعلمت أسرارًا سحرية جديدة. عندما حان وقت العودة، شعرت ليلى بحزن، لكنها عازمة على العودة مرة أخرى. قامت بمشاركة تجاربها المثيرة مع أهلها وأنشأوا غرفة سحرية في المنزل تصبح بوابة إلى عالم ليلى الخيالي.",
        "content": "One day, a little girl named Lily was born. Lily was a creative and curious girl who loved exploring the world and discovering new things. In the garden of her house, Lily discovered a hidden secret behind a small bush. When she opened the secret hiding spot, she found an amazing world filled with vibrant colors and delightful shapes. The trees could talk, and the animals communicated in a magical language. Lily met new friends like fairy princesses and intelligent animals. She enjoyed playing, dancing, and singing with them, and she learned new magical secrets. When it was time to return, Lily felt a tinge of sadness but was determined to come back again. She shared her exciting experiences with her family and they created a magical room in the house that became a gateway to Lily's imaginative world.",
        "title": "Lily's Imaginary World",
        "title-ar": "عالم ليلى الخيالي",
        "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/stories%2F2023-05-16%2007%3A48%3A12.672169.jpg?alt=media&token=f52ea93f-af03-4133-8b24-3e83cdfd4191"
      }
    ];

    for (Map<String, dynamic> data in stories) {
      await firestore
          .collection('users')
          .doc(ref)
          .collection('child-stories')
          .add(data);
    }

    List<Map<String, dynamic>> shortStories = [
      {
        'mainImage': 'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495782189?alt=media&token=2ee4c1fb-09e1-4efd-93c5-87ec3f303525',
        'title': 'The Starry Friendship',
        'title-ar': 'صداقة النجوم',
        'imagePaths': [
          {
            'text': 'Ethan sat on a lonely bench in the park',
            'text-ar': 'جلس إيثان على مقعد وحيد في الحديقة',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495770366?alt=media&token=0dfd81a1-8803-4592-882b-ca71c97b9afb'
          },
          {
            'text':
                "Suddenly, a shooting star streaked across the sky, captivating Ethan's attention.",
            'text-ar': 'فجأة ، خط نجم شهاب عبر السماء ، ولفت انتباه إيثان.',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495772261?alt=media&token=2ca5f617-b1a5-4c8c-aac8-f56768e2fcbd'
          },
          {
            'text':
                'At the school science fair, Ethan met Maya, a girl with a deep passion for astronomy.',
            'text-ar':
                'في معرض العلوم بالمدرسة ، التقى إيثان بمايا ، وهي فتاة شغوفة بعلم الفلك.',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495773591?alt=media&token=76989019-4b76-4359-b7d3-26d7a2494db5'
          },
          {
            'text':
                'From that day on, Ethan and Maya spent countless evenings together',
            'text-ar':
                'منذ ذلك اليوم ، أمضى إيثان ومايا أمسيات لا حصر لها معًا',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495774978?alt=media&token=87f73886-e34d-471a-951e-7cfcbb8dd306'
          },
          {
            'text':
                'In their journey, Ethan and Maya encountered challenges, but they faced them together. ',
            'text-ar':
                'في رحلتهم ، واجه إيثان ومايا تحديات ، لكنهما واجهوها معًا.',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495776270?alt=media&token=e6ea5054-4b1b-46d2-b0f1-c58af4c72748'
          },
          {
            'text':
                "As the years passed, Ethan and Maya's friendship grew stronger, shining brightly like a constellation in the sky.",
            'text-ar':
                "مع مرور السنين ، نمت صداقة إيثان ومايا بقوة ، وكانت تتألق مثل كوكبة في السماء.",
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495777590?alt=media&token=563e1df5-f626-4dfc-8e94-802d64eb2c53'
          },
          {
            'text':
                "Ethan and Maya's unique friendship inspired those around them, demonstrating that true connections can be found in unexpected places. ",
            'text-ar':
                'ألهمت صداقة إيثان ومايا الفريدة من حولهما ، مما يدل على أنه يمكن العثور على روابط حقيقية في أماكن غير متوقعة.',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495778909?alt=media&token=d94bd683-e65f-4b6e-a2b0-c42e69eb7eeb'
          },
        ]
      },
      {
        "mainImage": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495782189?alt=media&token=2ee4c1fb-09e1-4efd-93c5-87ec3f303525",
        "title": "Lily and the Magical Forest",
        "title-ar": "ليلي والغابة السحرية",
        "imagePaths": [
          {
            "text": "Lily, a young girl with an adventurous spirit, loved exploring the wonders of nature.",
            "text-ar": "ليلي ، فتاة صغيرة ذات روح مغامرة ، تحب استكشاف عجائب الطبيعة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495770366?alt=media&token=0dfd81a1-8803-4592-882b-ca71c97b9afb"
          },
          {
            "text": "One day, Lily discovered a hidden path in the forest.",
            "text-ar": "في يوم من الأيام ، اكتشفت ليلي طريقًا مخفيًا في الغابة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495772261?alt=media&token=2ca5f617-b1a5-4c8c-aac8-f56768e2fcbd"
          },
          {
            "text": "The path led her to a magical clearing, where she encountered Elderwood, the guardian of the forest.",
            "text-ar": "أدى الطريق بها إلى مساحة ساحرة ، حيث قابلت إلدروود ، حارس الغابة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495773591?alt=media&token=76989019-4b76-4359-b7d3-26d7a2494db5"
          },
          {
            "text": "Impressed by Lily's pure heart, Elderwood granted her the ability to communicate with animals.",
            "text-ar": "بتأثر قلب ليلي النقي ، منحها إلدروود القدرة على التحدث مع الحيوانات.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495774978?alt=media&token=87f73886-e34d-471a-951e-7cfcbb8dd306"
          },
          {
            "text": "Lily and her animal friends embarked on adventures, helping the forest and its inhabitants.",
            "text-ar": "انطلقت ليلي وأصدقاؤها الحيوانات في مغامرات ، مساعدة الغابة وسكانها.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495776270?alt=media&token=e6ea5054-4b1b-46d2-b0f1-c58af4c72748"
          },
          {
            "text": "Their bravery and kindness inspired others to appreciate and protect nature.",
            "text-ar": "ألهمت شجاعتهم ولطفهم الآخرين لتقدير وحماية الطبيعة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495777590?alt=media&token=563e1df5-f626-4dfc-8e94-802d64eb2c53"
          },
          {
            "text": "Lily became the Guardian of the Forest, spreading love and harmony between humans and nature.",
            "text-ar": "أصبحت ليلي حارسة الغابة ، تنشر الحب والسلام بين البشر والطبيعة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495778909?alt=media&token=d94bd683-e65f-4b6e-a2b0-c42e69eb7eeb"
          }
        ]
      },
      {
        "mainImage": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495782189?alt=media&token=2ee4c1fb-09e1-4efd-93c5-87ec3f303525",
        "title": "The Magical Journey of Leo and the Talking Forest",
        "title-ar": "رحلة ليو السحرية والغابة الحكيمة",
        "imagePaths": [
          {
            "text": "Leo, a curious young boy, loved to explore the forest near his village.",
            "text-ar": "ليو ، صبي شغوف ، يحب استكشاف الغابة بالقرب من قريته.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495770366?alt=media&token=0dfd81a1-8803-4592-882b-ca71c97b9afb"
          },
          {
            "text": "One day, Leo stumbled upon a hidden door at the base of a giant tree.",
            "text-ar": "في يوم من الأيام ، تعثر ليو على باب مخفي في أسفل شجرة ضخمة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495772261?alt=media&token=2ca5f617-b1a5-4c8c-aac8-f56768e2fcbd"
          },
          {
            "text": "As he entered the door, Leo found himself in a magical forest filled with talking animals.",
            "text-ar": "عندما دخل الباب ، وجد ليو نفسه في غابة سحرية مليئة بالحيوانات الحكيمة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495773591?alt=media&token=76989019-4b76-4359-b7d3-26d7a2494db5"
          },
          {
            "text": "Leo discovered that the animals could speak and shared incredible wisdom.",
            "text-ar": "اكتشف ليو أن الحيوانات يمكنها التحدث ومشاركة حكمة لا تصدق.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495774978?alt=media&token=87f73886-e34d-471a-951e-7cfcbb8dd306"
          },
          {
            "text": "Together, Leo and his new animal friends embarked on a quest to protect the forest from an evil sorcerer.",
            "text-ar": "معًا ، انطلق ليو وأصدقاؤه الحيوانات الجدد في مهمة لحماية الغابة من ساحر شرير.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495776270?alt=media&token=e6ea5054-4b1b-46d2-b0f1-c58af4c72748"
          },
          {
            "text": "With their combined strengths and courage, they defeated the sorcerer and saved the forest.",
            "text-ar": "بقوتهم المجتمعة وشجاعتهم ، هزموا الساحر وأنقذوا الغابة.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495777590?alt=media&token=563e1df5-f626-4dfc-8e94-802d64eb2c53"
          },
          {
            "text": "Leo and the animals became true heroes, celebrated by the forest's magical creatures.",
            "text-ar": "أصبح ليو والحيوانات أبطالًا حقيقيين ، يحتفى بهم من قبل مخلوقات الغابة السحرية.",
            "image": "https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/images%2Fimage_1684495778909?alt=media&token=d94bd683-e65f-4b6e-a2b0-c42e69eb7eeb"
          }
        ]
      }
    ];
    for (Map<String, dynamic> data in shortStories) {
      await firestore
          .collection('users')
          .doc(ref)
          .collection('child-short-stories')
          .add(data);
    }

    List<Map<String, dynamic>> videosCategories = [
      {'category': 'Skills', 'category-ar': 'مهارات','image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/vd_cat_imgs%2Fimage-removebg-preview%20(20).png?alt=media&token=cbe21a4e-122c-4c03-a22a-e0c713f0fca5&_gl=1*mrx82e*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTUxNzc3Ny43LjEuMTY4NTUxODc4OC4wLjAuMA..'},
      {'category': 'Learn', 'category-ar': 'تعلم','image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/vd_cat_imgs%2Fimage-removebg-preview%20(22).png?alt=media&token=6f5987e6-bc34-4723-89bd-f482a34efa8b&_gl=1*zvda4c*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTUxNzc3Ny43LjEuMTY4NTUxODgyOS4wLjAuMA..'},
      {'category': 'Communication', 'category-ar': 'التواصل','image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/vd_cat_imgs%2Fimage-removebg-preview%20(21).png?alt=media&token=4b83ba69-1bd7-4661-aa75-7a67365b27f7&_gl=1*ybexfw*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NTUxNzc3Ny43LjEuMTY4NTUxODgwOS4wLjAuMA..'},
    ];

    Map<int, List<Map<String, dynamic>>> videos = {
      0: [
        {
          'name': 'Thinking Skills',
          'name-ar': 'مهارات التفكير',
          'source': 'https://www.youtube.com/watch?v=oAZ0fc27qBY&pp=ygUo2YHZitiv2YrZiNmH2KfYqiDZhdmH2KfYsdin2Kog2YTZhNi32YHZhA%3D%3D',
          'sourceType': 'youtube'
        },{
          'name': 'Action Skills',
          'name-ar': 'مهارات الحركة',
          'source': 'https://www.youtube.com/watch?v=KXZ4ElMhniY&pp=ygUo2YHZitiv2YrZiNmH2KfYqiDZhdmH2KfYsdin2Kog2YTZhNi32YHZhA%3D%3D',
          'sourceType': 'youtube'
        },{
          'name': 'Visual Simulation',
          'name-ar': 'تحفيز بصري',
          'source': 'https://www.youtube.com/watch?v=iH0ZorRnP-8&pp=ygUo2YHZitiv2YrZiNmH2KfYqiDZhdmH2KfYsdin2Kog2YTZhNi32YHZhA%3D%3D',
          'sourceType': 'youtube'
        },{
          'name': 'Animal Memory Game',
          'name-ar': 'لعبة ذاكرة الحيوانات',
          'source': 'https://www.youtube.com/watch?v=qJ4P2qmYz_Q&pp=ygUo2YHZitiv2YrZiNmH2KfYqiDZhdmH2KfYsdin2Kog2YTZhNi32YHZhA%3D%3D',
          'sourceType': 'youtube'
        },{
          'name': 'Food etiquette',
          'name-ar': 'أداب الطعام',
          'source': 'https://www.youtube.com/watch?v=1wclOy6fo08&pp=ygVD2KjYsdin2YXYrCDYqtmG2YXZitipINmC2K_Ysdin2Kog2YTZhNij2LfZgdin2YQg2LnZhdixIDYg2LPZhtmI2KfYqg%3D%3D',
          'sourceType': 'youtube'
        },{
          'name': 'Brave',
          'name-ar': 'الشجاعة',
          'source': 'https://www.youtube.com/watch?v=gTsPitiKwTA&pp=ygUk2YHZitiv2YrZiNmH2KfYqiDZhdmH2KfYsdin2Kog2LfZgdmE',
          'sourceType': 'youtube'
        },
      ],
      1: [
        {
          'name': 'Arabic Alphabet',
          'name-ar': 'الحروف العربية',
          'source': 'https://www.youtube.com/watch?v=KoixiFgufJ4&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },{
          'name': 'Little Muslim',
          'name-ar': 'المسلم الصغير',
          'source': 'https://www.youtube.com/watch?v=LUvvLB8-h0w&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },{
          'name': 'Spell Colors',
          'name-ar': 'نطق الألوان',
          'source': 'https://www.youtube.com/watch?v=jUw8OHJz_Lk&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },{
          'name': 'Learn To Speel',
          'name-ar': 'تعلم النطق',
          'source': 'https://www.youtube.com/watch?v=HXc-lM3h4V4&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },{
          'name': 'Learn About Animals',
          'name-ar': 'تعلم عن الحيوانات',
          'source': 'https://www.youtube.com/watch?v=z01UZ8r_ZOw&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },{
          'name': 'Learn Numbers',
          'name-ar': 'تعلم الأرقام',
          'source': 'https://www.youtube.com/watch?v=Qnr6dl0xQV4&pp=ygUm2YHZitiv2YrZiNmH2KfYqiDYqti52YTZitmFINin2LfZgdin2YQ%3D',
          'sourceType': 'youtube',
        },
      ],
      2: [
        {
          'name':'Basic English Conversation',
          'name-ar':'محادثة انجليزية بسيطة',
          'source':'https://www.youtube.com/watch?v=by1QAoRcc-U&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        },{
          'name':'Social Skills',
          'name-ar':'مهارات اجتماعية',
          'source':'https://www.youtube.com/watch?v=Myf2CUx9E60&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        },{
          'name':'Saying What Do You Mean',
          'name-ar':'قل ما اللذي تعنيه حقا',
          'source':'https://www.youtube.com/watch?v=1hnLfnulwZw&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        },{
          'name':'Confidence',
          'name-ar':'الثقة في النفس',
          'source':'https://www.youtube.com/watch?v=pdjaxS4ME2A&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        },{
          'name':'Body Language',
          'name-ar':'لغة الجسد',
          'source':'https://www.youtube.com/watch?v=1sfM-xx7tHI&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        },{
          'name':'Effective Communication',
          'name-ar':'الحوار المؤثر',
          'source':'https://www.youtube.com/watch?v=JwjAAgGi-90&pp=ygUlY29tbXVuaWNhdGlvbiBza2lsbHMgdmlkZW9zIGZvciBjaGlsZA%3D%3D',
          'sourceType':'youtube'
        }
      ]
    };

    for (var i = 0; i < videosCategories.length; i++) {
      DocumentReference category = await firestore
          .collection('users')
          .doc(ref)
          .collection('child-videos')
          .add(videosCategories[i]);
      for (Map<String, dynamic> video in videos[i]!) {
        await firestore
            .collection('users')
            .doc(ref)
            .collection('child-videos')
            .doc(category.id)
            .collection('sources')
            .add(video);
      }
    }

    List<Map<String, dynamic>> learningTopics = [
      {
        'category': 'alphabet',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning-icons%2Falphapet.png?alt=media&token=44bee183-0027-45b8-9e59-5b30abaaee94'
      },
      {
        'category': 'vegetables',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning-icons%2Fvegetables.png?alt=media&token=a2e371c7-9c08-4997-a92e-f642f58ee8b1'
      },
      {
        'category': 'fruits',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning-icons%2Ffruits.png?alt=media&token=1fc42d0f-d79f-49a4-8d5c-b168dd49c65b'
      },
      {
        'category': 'Animals',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning-icons%2Fkingdom.png?alt=media&token=e509ac9c-2b44-42c2-a811-31294a1b1302'
      },
      {
        'category': 'Math',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/wants%2F2023-05-16%2020%3A38%3A35.140443.jpg?alt=media&token=39e73bee-5eda-490d-9f42-7162db255f9d'
      },
      {
        'category': 'Colors',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/th-removebg-preview.png?alt=media&token=f619d623-50d6-4644-8205-54928fc24c67'
      },
      {
        'category': 'arabic_alphabet',
        'iconImage':
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(4).png?alt=media&token=392c1173-c46c-47c1-9c5d-23aeb2744888'
      },
    ];

    Map<int, List<Map<String, dynamic>>> topicItems = {
      0: [
        {
          'name': 'E - Elephant',
          'name-ar': 'E - Elephant',
          'iconImage':
              'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A32%3A19.175135_icon.jpg?alt=media&token=c4f42d18-bfda-4671-887e-780cbdf4adf2',
          'images': [
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A32%3A21.583674_images%20(3).jpg?alt=media&token=1195e0a3-6552-4dfb-81d5-25ee0aadb661',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A32%3A22.686605_images%20(2).jpg?alt=media&token=a3cb117c-d575-401c-a7ce-b5b3f9b6db49',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A32%3A23.769452_download%20(12).jpg?alt=media&token=2e31b1ce-61d3-4fd5-a3d6-9e1f4f135a32'
          ]
        },
        {
          'name': 'A - Apple',
          'name-ar': 'A - Apple',
          'iconImage':
              'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A13%3A28.940863_icon.jpg?alt=media&token=da658cbc-7261-4732-8751-e547ffa4fee2',
          'images': [
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A13%3A33.379587_images.jpg?alt=media&token=f0f4d02c-d3b0-421e-8f4a-53a8ae67a086',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A13%3A35.939129_download%20(4).jpg?alt=media&token=50bc2e1e-7546-48d6-8e01-1ef8af2e5a13',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A13%3A37.324396_download%20(6).png?alt=media&token=4e875c45-7e96-46f0-8b91-deea8f9d05e9'
          ]
        },
        {
          'name': 'F - Fish',
          'name-ar': 'F - Fish',
          'iconImage':
              'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A36%3A18.701958_icon.jpg?alt=media&token=5de44d7f-4c42-4a00-b96f-ec1082d7757e',
          'images': [
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A36%3A21.460653_download%20(8).png?alt=media&token=4b9e07ac-ca73-4bdc-b633-39b42f0af216',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A36%3A23.033211_images%20(4).jpg?alt=media&token=5920ad1e-0261-4ea6-9b65-fd01338bd7ec',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A36%3A24.391120_download%20(13).jpg?alt=media&token=4169c0e3-fca3-460b-9d25-32140eecd0de'
          ]
        },
        {
          'name':'D - Dog',
          'name-ar':'D - Dog',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A22%3A54.607188_icon.jpg?alt=media&token=08b3ae7b-2ac4-4a64-8e64-81b32551e623',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A22%3A56.783348_download%20(11).jpg?alt=media&token=75d286ad-4238-486b-90d4-0bca1c499df7',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A22%3A57.830499_download%20(10).jpg?alt=media&token=d7fb5855-e5d4-4f1c-b02f-f8d0b45db348',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A22%3A58.965489_download%20(9).jpg?alt=media&token=7b6f7ec9-f23f-4f34-b15c-71def450f0cb'
          ]
        },{
          'name':'C - Cat',
          'name-ar':'C - Cat',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A19%3A58.338417_icon.jpg?alt=media&token=78360861-c2d4-401d-beab-f654537ae3a1',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A20%3A01.273198_download%20(8).jpg?alt=media&token=5b0e1ab3-018a-4860-94db-6ccf0c96e847',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A20%3A02.513005_download%20(7).jpg?alt=media&token=7abb76ba-6bfd-4a58-9d4d-3eaf43ea0e39',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A20%3A03.770846_download%20(6).jpg?alt=media&token=23961d9b-0435-47f7-a61e-1e8f0851dfd4'
          ]
        },{
        'name':'B - Bird',
          'name-ar':'B - Bird',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2Fimage-removebg-preview%20(3).png?alt=media&token=19d85b4e-6f7c-4d1a-9724-39d3be355bf4',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A16%3A36.253806_images%20(1).jpg?alt=media&token=f716292e-a8eb-4e4b-adde-9d4e830e8830',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A16%3A37.397127_download%20(5).jpg?alt=media&token=11bacb11-fbcc-461e-8385-676b9aa8b067',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2016%3A16%3A38.537347_download%20(7).png?alt=media&token=3cba5760-37f2-4d93-94d9-464fe4b1d596'
          ]
        }
      ],
      1: [
        {
          'name':'Potatoes',
          'name-ar':'بطاطس',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A58%3A34.437536_icon.jpg?alt=media&token=0a202e4d-cabe-4dbf-a6de-62c0af56907b'
        },{
          'name':'Tomatoes',
          'name-ar':'طماطم',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A57%3A56.505476_icon.jpg?alt=media&token=94b06cf5-5140-4633-b567-c5544296315a'
        },{
          'name':'Onion',
          'name-ar':'بصل',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A59%3A31.382518_icon.jpg?alt=media&token=1845d459-ee4b-4267-855a-93b729edebb4'
        },{
          'name':'Carrot',
          'name-ar':'جزر',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A59%3A06.864790_icon.jpg?alt=media&token=65932ee3-7b69-4143-94cf-95814ac16bfc'
        },{
          'name':'Cucumbers',
          'name-ar':'خيار',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A59%3A58.031969_icon.jpg?alt=media&token=2b787489-764a-474e-987c-4558ca7f6a29'
        },{
          'name':'Chilli',
          'name-ar':'فلفل',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2018%3A00%3A19.629819_icon.jpg?alt=media&token=78f60130-7d71-4b7d-96d5-4a9e162a421d'
        }
      ],
      2: [
        {
          'name':'Banana',
          'name-ar':'موزة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A20%3A34.907217_icon.jpg?alt=media&token=b66bd263-7f84-4466-8eb1-3aef4f5d49e9'
        },{
          'name':'Strawberry',
          'name-ar':'فراولة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A37%3A22.946998_icon.jpg?alt=media&token=e2abd84d-3bf4-48e2-896f-0323b29ac95d'
        },{
          'name':'Apple',
          'name-ar':'تفاحة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A17%3A59.229776_icon.jpg?alt=media&token=0bf09d11-ab52-4210-a1f5-3f46f6c21931'
        },{
          'name':'Watermelon',
          'name-ar':'بطيخة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A39%3A29.052340_icon.jpg?alt=media&token=17c2b443-5b3f-4126-95b7-ed70d32072d3'
        },{
          'name':'Peach',
          'name-ar':'خوخ',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A36%3A30.542351_icon.jpg?alt=media&token=8c2a8c25-b4d4-4e4b-8b7b-9d4082eb8a45'
        },{
          'name':'Pineapple',
          'name-ar':'أناناس',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2017%3A38%3A26.266669_icon.jpg?alt=media&token=6b2e323e-9823-4c8a-80a0-466a54373d21'
        },
      ],
      3: [
        {
          'name':'Butterfly',
          'name-ar':'فراشة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2015%3A48%3A58.025111_icon.jpg?alt=media&token=454781a6-163d-4a6a-84eb-d32feb45a5bf'
        },{
          'name':'Bird',
          'name-ar':'طائر',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2015%3A46%3A23.406027_icon.jpg?alt=media&token=1b7b16c5-d09e-47c5-abfc-6adc1aa2fcdd'
        },{
          'name':'Cat',
          'name-ar':'قطة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2008%3A11%3A42.810151_icon.jpg?alt=media&token=c47c6e79-a3ff-4cd3-a358-ee70407aa8d8'
        },{
          'name':'Horse',
          'name-ar':'حصان',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2015%3A38%3A00.407561_icon.jpg?alt=media&token=b3e8b2b1-b042-4b54-9d50-5c8d20c6f3cc'
        },{
          'name':'Bear',
          'name-ar':'دب',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2015%3A42%3A19.828044_icon.jpg?alt=media&token=b84271aa-b962-48c0-a29f-13a24685a275'
        },{
          'name':'Dog',
          'name-ar':'كلب',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-17%2008%3A18%3A35.596287_icon.jpg?alt=media&token=2de6b180-7183-4f39-b5ee-babaaad2a155'
        },
      ],
      4: [
        {
          'name':'Addition',
          'name-ar':'الجمع',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A17%3A39.856541_icon.jpg?alt=media&token=580fa080-c9dd-430b-947c-c66bd332fc36',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A17%3A41.884448_images%20(13).jpg?alt=media&token=b4661f87-88c8-47fd-bd2a-199e6fb04f59',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A17%3A42.896958_images%20(12).jpg?alt=media&token=4a70cb49-fd95-48e3-9e48-242936c6e7cb'
          ]
        },{
          'name':'Counting Numbers',
          'name-ar':'عد الارقام',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A00.878732_icon.jpg?alt=media&token=1b233121-e5b6-4359-86e5-da30fb89723e',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A05.788286_images%20(9).jpg?alt=media&token=8f3d6077-e00d-4311-a59b-fb280ab92753',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A06.781203_images%20(10).jpg?alt=media&token=91eea14d-06df-4e63-9447-bc20dc307c84',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A04.598752_images%20(8).jpg?alt=media&token=ca76927b-7029-4590-8777-62a1d5fcd6e7',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A07.979669_download%20(10).png?alt=media&token=19e402d6-a8a1-400a-b75d-3ea0e166d87c',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A09.039111_images.png?alt=media&token=670cfb4f-8748-44ec-b990-b47d21c50efe'
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A10.044394_images%20(12).jpg?alt=media&token=1521e813-dd08-420c-8e4f-a281892cef97',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A11.124631_images%20(13).jpg?alt=media&token=197bac8e-19b9-42e9-a003-2f23ebbe3399',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A12.136624_download%20(11).png?alt=media&token=53046498-0251-43bb-beb2-bd68be6dbf34'
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A13.190447_images%20(1).png?alt=media&token=48cbd28f-cf67-41f0-a36e-0a909097edb5',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A14%3A14.069179_download%20(20).jpg?alt=media&token=21925afd-4c6e-421c-8897-c1a56301f5bb'
          ]
        },{
          'name':'Shapes',
          'name-ar':'الأشكال',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A31%3A45.029526_icon.jpg?alt=media&token=2132fd72-a963-4c1d-b2ec-c7a9eeb38554',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A31%3A47.405708_images%20(14).jpg?alt=media&token=b4e43685-8b17-4d4f-a466-ebb33dcc9467',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A31%3A48.330993_images%20(15).jpg?alt=media&token=1836f37c-cac6-4d17-8f93-e2c2dfa9a62e',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A31%3A49.433244_download%20(21).jpg?alt=media&token=815f29f1-bb1a-4ea4-9a71-f050e58203e2'
          ]
        },{
          'name':'Subtraction',
          'name-ar':'الطرح',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A19%3A34.932742_icon.jpg?alt=media&token=f1115d82-936f-4286-ab96-a75c8a50d4ae',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A19%3A38.668637_images%20(1).png?alt=media&token=5e081275-e540-48f5-aa5d-2e4585470068',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A19%3A39.571986_download%20(20).jpg?alt=media&token=2b615a27-2e15-4e47-b5c1-7be98a606242',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A19%3A40.556356_download%20(11).png?alt=media&token=d0031201-cb56-47fe-960f-ba323c80e461',
          ]
        },{
          'name':'Patterns',
          'name-ar':'الانماط',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A45.730601_icon.jpg?alt=media&token=e4a8456e-8b95-4ec1-b7e9-cac87c8cd033',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A48.305551_images%20(17).jpg?alt=media&token=832dd94c-bbb9-49c3-af86-c455eb83a530',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A51.016952_images%20(18).jpg?alt=media&token=3f81e180-1f47-4e3c-893b-8884cfa92964',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A51.909676_images%20(19).jpg?alt=media&token=1998815b-761a-4a67-8c96-fdc494aa9bd8',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A52.976314_images%20(16).jpg?alt=media&token=caf625d6-42a2-4dd9-900e-8e36a8ab9369',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A30%3A54.163353_images%20(20).jpg?alt=media&token=9b632b39-2fe8-47aa-8e85-7b373af39184'
          ]
        },{
          'name':'Time',
          'name-ar':'الوقت',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A29%3A08.031402_icon.jpg?alt=media&token=3b239db2-b004-47a9-bf75-1f2bd829c880',
          'images':[
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A29%3A10.636257_download%20(24).jpg?alt=media&token=5577c3db-791d-49d2-a3c3-2005fd017843',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A29%3A11.525339_download%20(23).jpg?alt=media&token=4776cd6e-769c-4cb7-a787-6f5f4cebeb75',
            'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/learning%2F2023-05-18%2007%3A29%3A12.500289_download%20(22).jpg?alt=media&token=3cf5f444-1f99-419d-8ab8-2015010a0b75'
          ]
        },
      ],
      5: [
        {
          'name':'Purble',
          'name-ar':'بنفسجي',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2Fpurple.jpg?alt=media&token=356da66b-74db-404f-babe-9f4c27912321'
        },{
          'name':'Red',
          'name-ar':'أحمر',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2Fdownload%20(5).jpg?alt=media&token=1eddd438-8763-48fc-bcdd-d21ccb6815a4'
        },{
          'name':'Blue',
          'name-ar':'أزرق',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2Fdownload%20(4).jpg?alt=media&token=bc419585-c116-4c78-a4e3-d612b313b5ff'
        },{
          'name':'Green',
          'name-ar':'أخضر',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2FOIP%20(5).jpg?alt=media&token=8429896f-e14e-40d1-9e4f-de4f89332224'
        },{
          'name':'Black',
          'name-ar':'أسود',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2FOIP%20(6).jpg?alt=media&token=e9e4bae4-0b5d-40aa-9271-29f2410c4b2d'
        },{
          'name':'Yellow',
          'name-ar':'أصفر',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/colors%2FOIP%20(4).jpg?alt=media&token=03bf9d82-9d85-4247-9948-7f8640cd5e15'
        },
      ],
      6: [
        {
          'name':'أ - أرنب',
          'images':[],
          'name-ar':'أ - أرنب',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(30).png?alt=media&token=c64edaac-81a7-4113-90b3-a53035b2927a&_gl=1*1d18nmz*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NjAwNTMxMy4xNS4xLjE2ODYwMDUzOTYuMC4wLjA.'
        },{
          'name':'ب - بطة',
          'name-ar':'ب - بطة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/arabic%2Fimage-removebg-preview%20(6).png?alt=media&token=b469fbcb-52a5-41ba-ae4a-cce5eccba9a2'
        },{
          'name':'ت - تفاحة',
          'name-ar':'ت - تفاحة',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/arabic%2Fimage-removebg-preview%20(10).png?alt=media&token=58874e49-f910-460e-9815-9a11bb74790c'
        },{
          'name':'ث - ثعلب',
          'images':[],
          'name-ar':'ث - ثعلب',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(29).png?alt=media&token=44ddd4e1-f753-40cc-981b-4027bdd7d03a&_gl=1*non3w5*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NjAwNTMxMy4xNS4xLjE2ODYwMDU0ODEuMC4wLjA.'
        },{
          'name':'ج - جمل',
          'name-ar':'ج - جمل',
          'images':[],
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/arabic%2Fimage-removebg-preview%20(8).png?alt=media&token=9b6bc07a-2a5b-42f6-a27c-96bd1cda4d28'
        },{
          'name':'ح - حصان',
          'images':[],
          'name-ar':'ح - حصان',
          'iconImage':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/temp%2Fimage-removebg-preview%20(31).png?alt=media&token=5c73a2d6-746a-4433-b8f5-c7ffb3d71897&_gl=1*1id0vku*_ga*NzY2NzA5OTA4LjE2ODExMDkzMTU.*_ga_CW55HF8NVT*MTY4NjAwNTMxMy4xNS4xLjE2ODYwMDU1MTAuMC4wLjA.'
        },
      ],
    };

    for (var i = 0; i < learningTopics.length; i++) {
      DocumentReference category = await firestore
          .collection('users')
          .doc(ref)
          .collection('child-learning')
          .add(learningTopics[i]);
      for (Map<String, dynamic> items in topicItems[i]!) {
        await firestore
            .collection('users')
            .doc(ref)
            .collection('child-learning')
            .doc(category.id)
            .collection('items')
            .add(items);
      }
    }


    List<Map<String,dynamic>> testCategories =  [
      {'category':'Alphabet','category-ar':'الأبجدية'},
      {'category':'Math','category-ar':'الرياضيات'},
      {'category':'Colors','category-ar':'الالوان'},
      {'category':'Tools','category-ar':'الاشياء'},
      {'category':'Shapes','category-ar':'الاشكال'},
      {'category':'Animals','category-ar':'الحيوانات'},
    ];

    Map<int,List<Map<String,dynamic>>> testCategoryQuestions = {
      0: [
        {
          'choices': ['i','o','L','n'],
          'choices-ar': ['i','o','L','n'],
          'answer':2,
          'question':"What Letter Does Word 'Lion' Starts With?",
          'question-ar':"'Lion' بأي حرف تبأ هذة الكلمة ",
          'hint':'',
          'hint-ar':'',
          'description':'',
          'description-ar':''
        },
        {
          "choices": ["A", "E", "C", "D"],
          "choices-ar": ["A", "E", "C", "D"],
          "answer": 1,
          "question": "What letter does the word 'Elephant' start with?",
          "question-ar": "بأي حرف تبدأ كلمة 'Elephant'",
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "choices": ["P", "N", "R", "S"],
          "choices-ar": ["P", "N", "R", "S"],
          "answer": 1,
          "question": "What letter does the word 'Sun' end with?",
          "question-ar": "بأي حرف تنتهي كلمة 'Sun'",
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "choices": ["M", "N", "O", "P"],
          "choices-ar": ["M", "N", "O", "P"],
          "answer": 0,
          "question": "What letter does the word 'Monkey' start with?",
          "question-ar": "بأي حرف تبدأ كلمة 'Monkey'؟",
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "choices": ["L", "m", "n", "o"],
          "choices-ar": ["L", "m", "n", "o"],
          "answer": 2,
          "question": "What letter does the word 'Lion' end with?",
          "question-ar": "بأي حرف تنتهي هذه الكلمة 'Lion'؟",
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "choices": ["h", "d", "e", "F"],
          "choices-ar": ["h", "d", "e", "F"],
          "answer": 3,
          "question": "What letter does the word 'Fish' end with?",
          "question-ar": "بأي حرف تنتهي هذه الكلمة 'Fish'؟",
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ],
      1: [
        {
          'question':'The Number of Dog Legs Are?',
          'question-ar':'كم عدد ارجل الكلب؟',
          'choices':['10','6','1','4'],
          'choices-ar':['10','6','1','4'],
          'answer':3,
          'hint':'',
          'hint-ar':'',
          'description':'',
          'description-ar':'',
        },{
          'question':'what is 2 + 2?',
          'question-ar':'كم يساوي 2 + 2',
          'choices':['4','2','0','8'],
          'choices-ar':['4','2','0','8'],
          'answer':0,
          'hint':'',
          'hint-ar':'',
          'description':'',
          'description-ar':'',
        },{
          'question':'How Many Numbers In Human Eyes?',
          'question-ar':'كم عين لدي االانسان؟',
          'choices':['1','3','2','4'],
          'choices-ar':['1','3','2','4'],
          'answer':2,
          'hint':'',
          'hint-ar':'',
          'description':'',
          'description-ar':'',
        },{
          "question": "How Many Days Are There in a Week?",
          "question-ar": "كم عدد أيام الأسبوع؟",
          "choices": ["7", "5", "10", "3"],
          "choices-ar": ["7", "5", "10", "3"],
          "answer": 0,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "How Many Sides Does a Triangle Have?",
          "question-ar": "كم عدد أضلاع المثلث؟",
          "choices": ["3", "4", "6", "2"],
          "choices-ar": ["3", "4", "6", "1"],
          "answer": 0,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "How Many Legs Does a Spider Have?",
          "question-ar": "كم عدد أرجل العنكبوت؟",
          "choices": ["6", "8", "4", "2"],
          "choices-ar": ["6", "8", "4", "2"],
          "answer": 1,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ],
      2: [
        {
          'question':'What Is The Color Of Sky?',
          'question-ar':'ما هو لون السماء؟',
          'answer':1,
          'choices':['Red','Blue','Green','Purple'],
          'choices-ar':['أحمر','أزرق','أخضر','بنفسجي'],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/new.jpg?alt=media&token=c95ff8cc-dfcc-4e00-8100-14e3d541ae36',
          'hint':'Look At The Sky',
          'hint-ar':'أنظر الي السماء',
          'description':'',
          'description-ar':'',
        },{
          "question": "What color is a banana?",
          "question-ar": "ما هو لون الموز؟",
          "choices": ["Yellow", "Red", "Green", "Blue"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2F2023-05-16%2021%3A50%3A04.135790.png?alt=media&token=9e1b9182-13b8-4de0-a7ba-1c6cc4dcb347',
          "choices-ar": ["أصفر", "أحمر", "أخضر", "أزرق"],
          "answer": 0,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What color is a lemon?",
          "question-ar": "ما هو لون الليمون؟",
          "choices": ["Purple", "Green", "Yellow", "Blue"],
          "choices-ar": ["نفسجي", "أخضر", "أصفر", "أزرق"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(11).png?alt=media&token=684f817b-41ea-4e53-927d-e224172adeac',
          "answer": 2,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What color is a tomato?",
          "question-ar": "ما هو لون الطماطم؟",
          "choices": ["Yellow", "Blue", "Red", "Green"],
          "choices-ar": ["أصفر", "أزرق", "أحمر", "أخضر"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(12).png?alt=media&token=fd1e60fc-6861-4b6e-8065-1aebc8b2706e',
          "answer": 2,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What color is grass?",
          "question-ar": "ما هو لون العشب؟",
          "choices": ["Purple", "Orange", "Green", "Red"],
          "choices-ar": ["بنفسجي", "برتقالي", "أخضر", "أحمر"],
          "answer": 2,
          "hint": "",
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/OIP%20(7).jpg?alt=media&token=968d40c0-63d8-4fc5-b372-9f5f1585a628',
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What color is an orange?",
          "question-ar": "ما هو لون البرتقالة؟",
          "choices": ["Yellow", "Blue", "Green", "Orange"],
          "choices-ar": ["أصفر", "أزرق", "أخضر", "برتقالي"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/OIP%20(8).jpg?alt=media&token=a1b78769-b525-49a2-abac-f031c3cb70f6',
          "answer": 3,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ],
      3: [
        {
          "question": "What tool do you use to write?",
          "question-ar": "ما الجسم الذي تستخدمه للكتابة؟",
          "choices": ["Pen", "Spoon", "Shoe", "Plate"],
          "choices-ar": ["قلم", "ملعقة", "حذاء", "طبق"],
          "answer": 0,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2F2023-05-17%2007%3A46%3A43.175481.png?alt=media&token=bfd5cf16-5994-4f82-9058-8e16105de2ca',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What tool do you use to eat soup?",
          "question-ar": "ما الجسم الذي تستخدمه لتناول الشوربة؟",
          "choices": ["Chair", "Table", "Cup", "Spoon"],
          "choices-ar": ["كرسي", "طاولة", "فنجان", "ملعقة"],
          "answer": 3,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(17).png?alt=media&token=b72d99d3-277f-4c53-a6c2-adb63fac06c6',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What tool do you use to open doors?",
          "question-ar": "ما الجسم الذي تستخدمه لفتح الأبواب؟",
          "choices": ["Key", "Book", "Phone", "Bottle"],
          "choices-ar": ["مفتاح", "كتاب", "تليفون", "زجاجة"],
          "answer": 0,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/OIP%20(10).jpg?alt=media&token=d2624e2a-48c4-45d7-b092-10c996fa5701',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What tool do you use to sleep on?",
          "question-ar": "ما الجسم الذي تستخدمه للنوم عليه؟",
          "choices": ["Pillow", "Shirt", "Chair", "Plate"],
          "choices-ar": ["وسادة", "شيرت", "كرسي", "طبق"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(15).png?alt=media&token=a794913e-184b-4e53-8d74-1a2a7b7747b0',
          "answer": 0,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What tool do you use to see your reflection?",
          "question-ar": "ما الجسم الذي تستخدمه لرؤية انعكاسك؟",
          "choices": ["Mirror", "Shoe", "Table", "Cup"],
          "choices-ar": ["مراه", "حذاء", "طاولة", "فنجان"],
          "answer": 0,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/OIP%20(9).jpg?alt=media&token=9eeb0943-11d2-4cf7-856b-64b4accbedcf',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What tool do you use to cut paper?",
          "question-ar": "ما الجسم الذي تستخدمه لقص الورق؟",
          "choices": ["Pen", "Scissors", "Phone", "Bottle"],
          "choices-ar": ["قلم", "مقص", "رقم هاتف", "زجاجة"],
          "answer": 1,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/image-removebg-preview%20(13).png?alt=media&token=403f6410-2ea0-4db3-ab87-92f516483226',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ],
      4: [
        {
          "question": "Which shape has three sides?",
          "question-ar": "أي شكل له ثلاثة أضلاع؟",
          "choices": ["Square", "Triangle", "Circle", "Rectangle"],
          "choices-ar": ["مربع", "مثلث", "دائرة", "مستطيل"],
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2Fth-removebg-preview%20(1).png?alt=media&token=65e319da-663a-43c0-a309-22ffa32de9ee',
          "answer": 1,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": "",
        },{
          "question": "Which shape has four equal sides?",
          "question-ar": "أي شكل له أربعة أضلاع متساوية؟",
          "choices": ["Square", "Triangle", "Circle", "Rectangle"],
          "choices-ar": ["مربع", "مثلث", "دائرة", "مستطيل"],
          "answer": 0,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2Fimage-removebg-preview%20(18).png?alt=media&token=3e9acb27-3872-4f83-940a-61ac3a8fed92',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which shape is round?",
          "question-ar": "أي شكل هو دائري؟",
          "choices": ["Square", "Triangle", "Circle", "Rectangle"],
          "choices-ar": ["مربع", "مثلث", "دائرة", "مستطيل"],
          "answer": 2,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2F2023-05-17%2007%3A53%3A39.295879.png?alt=media&token=c51a9792-f146-46ec-b929-6d4557a0679d',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "What is the shape of egg?",
          "question-ar": "ما هو شكل الدائرة",
          "choices": ["Square", "Triangle", "Oval", "Rectangle"],
          "choices-ar": ["مربع", "مثلث", "بيضاوي", "مستطيل"],
          "answer": 2,
          'image':'https://firebasestorage.googleapis.com/v0/b/aia-children-v3.appspot.com/o/question_images%2Fimage-removebg-preview%20(19).png?alt=media&token=c7078290-31ab-46d2-a8eb-80557ad7e523',
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ],
      5: [
        {
          "question": "Which animal trumpets?",
          "question-ar": "أي حيوان يصدر صوت الفيل؟",
          "choices": ["Dog", "Cat", "Bird", "Elephant"],
          "choices-ar": ["كلب", "قطة", "طائر", "فيل"],
          "answer": 3,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which animal neighs?",
          "question-ar": "أي حيوان يصدر صوت الحصان؟",
          "choices": ["Dog", "Cat", "Horse", "Elephant"],
          "choices-ar": ["كلب", "قطة", "حصان", "فيل"],
          "answer": 2,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which animal roars?",
          "question-ar": "أي حيوان يصدر صوت الأسد؟",
          "choices": ["Dog", "Cat", "Bird", "Lion"],
          "choices-ar": ["كلب", "قطة", "طائر", "أسد"],
          "answer": 3,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which animal tweets?",
          "question-ar": "أي حيوان يصدر صوت الشجرة؟",
          "choices": ["Dog", "Cat", "Bird", "Elephant"],
          "choices-ar": ["كلب", "قطة", "طائر", "فيل"],
          "answer": 2,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which animal meows?",
          "question-ar": "أي حيوان يصدر صوت النياو؟",
          "choices": ["Dog", "Cat", "Bird", "Elephant"],
          "choices-ar": ["كلب", "قطة", "طائر", "فيل"],
          "answer": 1,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        },{
          "question": "Which animal barks?",
          "question-ar": "أي حيوان ينبح؟",
          "choices": ["Dog", "Cat", "Bird", "Elephant"],
          "choices-ar": ["كلب", "قطة", "طائر", "فيل"],
          "answer": 0,
          "hint": "",
          "hint-ar": "",
          "description": "",
          "description-ar": ""
        }
      ]
    };

    for (var i = 0; i < testCategories.length; i++) {
      DocumentReference category = await firestore
          .collection('users')
          .doc(ref)
          .collection('child-tests')
          .add(testCategories[i]);
      for (Map<String, dynamic> items in testCategoryQuestions[i]!) {
        await firestore
            .collection('users')
            .doc(ref)
            .collection('child-tests')
            .doc(category.id)
            .collection('questions')
            .add(items);
      }
    }


    CollectionReference scores = firestore.collection('users').doc(ref).collection('child-scores');
    CollectionReference history = firestore.collection('users').doc(ref).collection('child-history');
    CollectionReference voices = firestore.collection('users').doc(ref).collection('child-voice-commands');
    try {
      await voices.add({
        'prompt':'how are you',
        'prompt-ar':'كيف حالك',
        'answer':"i'm fine thank you",
        'answer-ar':'انا بخير شكرا لك'
      });

      DocumentReference historyRef = await history.add({});
      DocumentReference scoresRef = await scores.add({});


      await historyRef.delete();
      await scoresRef.delete();
      print('Empty collection created successfully!');
    } catch (e) {
      print('Error creating empty collection: $e');
    }
  }
}
