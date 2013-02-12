Return-Path: <aaronc@cse.unsw.edu.au>
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Tue, 12 Feb 2013 12:53:23 +1100
Message-ID: <5119A093.2030409@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Re: problem FIO compiling for Android
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com> <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com> <20130211172550.GU21269@kernel.dk>
In-Reply-To: <20130211172550.GU21269@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------080104060106000603010302"
To: Jens Axboe <axboe@kernel.dk>
Cc: David N <android.wm.edu@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080104060106000603010302
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On 12/02/13 4:25 AM, Jens Axboe wrote:
> On Mon, Feb 11 2013, David N wrote:
>> Hello Everyone,
>>
>> I've been trying to compile FIO for Android but keep getting error
>> bellow. Can anybody give me any guidance please?
>>
>> I very much appreciate!
>>
>> David
>>
>>
>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
>> UNAME=Android CROSS_COMPILE=$CCOMPILER
>>     CC init.o
>> init.c: In function ‘free_shm’:
>> init.c:224:18: error: storage size of ‘sbuf’ isn’t known
>> init.c:233:3: warning: implicit declaration of function ‘shmdt’
>> [-Wimplicit-function-declaration]
>> init.c:234:3: warning: implicit declaration of function ‘shmctl’
>> [-Wimplicit-function-declaration]
>> init.c:224:18: warning: unused variable ‘sbuf’ [-Wunused-variable]
>> init.c: In function ‘setup_thread_area’:
>> init.c:263:3: warning: implicit declaration of function ‘shmget’
>> [-Wimplicit-function-declaration]
>> init.c:277:2: warning: implicit declaration of function ‘shmat’
>> [-Wimplicit-function-declaration]
>> init.c:277:10: warning: assignment makes pointer from integer without
>> a cast [enabled by default]
>> make: *** [init.o] Error 1
> 
> Lets CC in Aaron, who added the port.

The switch to configure broke Android.  I got a very minimal build
working with the attached patch and:

  make
cross_prefix=~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-
UNAME=Android


Hope that helps,
  -- Aaron


--------------080104060106000603010302
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="fio-android-configure.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fio-android-configure.patch"

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggOGE3NDEwYS4uYmIzNDVl
ZCAxMDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTkwLDcgKzkwLDYg
QEAgaWZlcSAoJChVTkFNRSksIEFuZHJvaWQpCiAgIFNPVVJDRSArPSBkaXNrdXRpbC5jIGZp
Zm8uYyBibGt0cmFjZS5jIHRyaW0uYyBwcm9maWxlcy90aW9iZW5jaC5jCiAgIExJQlMgKz0g
LWxkbAogICBMREZMQUdTICs9IC1yZHluYW1pYwotICBDUFBGTEFHUyArPSAtREZJT19OT19I
QVZFX1NITV9ICiBlbmRpZgogaWZlcSAoJChVTkFNRSksIFN1bk9TKQogICBMSUJTCSArPSAt
bHB0aHJlYWQgLWxkbCAtbGFpbyAtbHJ0IC1sbnNsIC1sc29ja2V0CmRpZmYgLS1naXQgYS9j
b25maWd1cmUgYi9jb25maWd1cmUKaW5kZXggODdjYzFjZi4uODI2N2UxYyAxMDA3NTUKLS0t
IGEvY29uZmlndXJlCisrKyBiL2NvbmZpZ3VyZQpAQCAtMTYxLDcgKzE2MSw5IEBAIGlmIHRl
c3QgIiRzaG93X2hlbHAiID0gInllcyIgOyB0aGVuCiAgIGV4aXQgJGV4aXRfdmFsCiBmaQog
Ci1pZiBjaGVja19kZWZpbmUgX19saW51eF9fIDsgdGhlbgoraWYgY2hlY2tfZGVmaW5lIF9f
QU5EUk9JRF9fIDsgdGhlbgorICB0YXJnZXRvcz0iQW5kcm9pZCIKK2VsaWYgY2hlY2tfZGVm
aW5lIF9fbGludXhfXyA7IHRoZW4KICAgdGFyZ2V0b3M9IkxpbnV4IgogZWxpZiBjaGVja19k
ZWZpbmUgX19PcGVuQlNEX18gOyB0aGVuCiAgIHRhcmdldG9zPSdPcGVuQlNEJwpAQCAtMjIy
LDYgKzIyNCwxNSBAQCBDWUdXSU4qKQogICBlY2hvICJDQz0kQ0MiID4+ICRjb25maWdfaG9z
dF9tYWsKICAgZWNobyAiRVhURkxBR1M9JENGTEFHUyAtaW5jbHVkZSBjb25maWctaG9zdC5o
IC1EX0dOVV9TT1VSQ0UiID4+ICRjb25maWdfaG9zdF9tYWsKICAgZXhpdCAwCisgIDs7CitB
bmRyb2lkKQorICBvdXRwdXRfc3ltICJDT05GSUdfMzJCSVQiCisgIG91dHB1dF9zeW0gIkNP
TkZJR19TT0NLTEVOX1QiCisgIG91dHB1dF9zeW0gIkNPTkZJR19HRVRUSU1FT0ZEQVkiCisg
IG91dHB1dF9zeW0gIkNPTkZJR19DTE9DS19HRVRUSU1FIgorICBlY2hvICJDQz0kY2MiID4+
ICRjb25maWdfaG9zdF9tYWsKKyAgZWNobyAiRVhURkxBR1M9JENGTEFHUyAtaW5jbHVkZSBj
b25maWctaG9zdC5oIC1ERklPX05PX0hBVkVfU0hNX0ggLURfR05VX1NPVVJDRSIgPj4gJGNv
bmZpZ19ob3N0X21haworICBleGl0IDAKIGVzYWMKIAogaWYgdGVzdCAhIC16ICIkY3B1IiA7
IHRoZW4KZGlmZiAtLWdpdCBhL29zL29zLWFuZHJvaWQuaCBiL29zL29zLWFuZHJvaWQuaApp
bmRleCBlNDM2ZjhmLi5jZWRmZGFmIDEwMDY0NAotLS0gYS9vcy9vcy1hbmRyb2lkLmgKKysr
IGIvb3Mvb3MtYW5kcm9pZC5oCkBAIC0zMCw2ICszMCw3IEBACiAjZGVmaW5lIEZJT19VU0Vf
R0VORVJJQ19JTklUX1JBTkRPTV9TVEFURQogI2RlZmluZSBGSU9fSEFWRV9FNF9FTkcKICNk
ZWZpbmUgRklPX0hBVkVfQllURU9SREVSX0ZVTkNTCisjZGVmaW5lIEZJT19IQVZFX01NQVBf
SFVHRQogCiAjZGVmaW5lIE9TX01BUF9BTk9OCQlNQVBfQU5PTllNT1VTCiAK
--------------080104060106000603010302--


