Return-Path: <prvs=474eabae4=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 1/4] configure: improve libzbc version check
Date: Fri, 31 Jul 2020 07:02:58 +0000
Message-ID: 
 <MWHPR04MB3758D28CB60D782D5C4752AEE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-2-dmitry.fomichev@wdc.com>
 <CY4PR04MB3751CCE0FB675C4906F9C414E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <MN2PR04MB59519F3A6FCC32DFCEC891B3E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/31 8:09, Dmitry Fomichev wrote:=0A=
> =0A=
> =0A=
>> -----Original Message-----=0A=
>> From: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
>> Sent: Thursday, July 30, 2020 12:54 AM=0A=
>> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe=0A=
>> <axboe@kernel.dk>=0A=
>> Cc: fio@vger.kernel.org; Shinichiro Kawasaki=0A=
>> <shinichiro.kawasaki@wdc.com>=0A=
>> Subject: Re: [PATCH v2 1/4] configure: improve libzbc version check=0A=
>>=0A=
>> On 2020/07/30 6:04, Dmitry Fomichev wrote:=0A=
>>> Avoid parsing pkg-config output and just use --atleast-version to=0A=
>>> check if libzbc is present and has an up to date version.=0A=
>>>=0A=
>>> Currently, support for libzbc ioengine is always included if libzbc is=
=0A=
>>> found at the build system. Add the option to disable libzbc ioengine=0A=
>>> support even if libzbc is found. This can be useful for=0A=
>>> cross-compilation.=0A=
>>>=0A=
>>> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
>>> ---=0A=
>>>  configure | 28 +++++++++++++++-------------=0A=
>>>  1 file changed, 15 insertions(+), 13 deletions(-)=0A=
>>>=0A=
>>> diff --git a/configure b/configure=0A=
>>> index 5925e94f..9a5f35f2 100755=0A=
>>> --- a/configure=0A=
>>> +++ b/configure=0A=
>>> @@ -213,6 +213,8 @@ for opt do=0A=
>>>    ;;=0A=
>>>    --enable-libnbd) libnbd=3D"yes"=0A=
>>>    ;;=0A=
>>> +  --disable-libzbc) libzbc=3D"no"=0A=
>>> +  ;;=0A=
>>>    --disable-tcmalloc) disable_tcmalloc=3D"yes"=0A=
>>>    ;;=0A=
>>>    --enable-libaio-uring) libaio_uring=3D"yes"=0A=
>>> @@ -256,6 +258,7 @@ if test "$show_help" =3D "yes" ; then=0A=
>>>    echo "--with-ime=3D             Install path for DDN's Infinite Memo=
ry Engine"=0A=
>>>    echo "--enable-libiscsi       Enable iscsi support"=0A=
>>>    echo "--enable-libnbd         Enable libnbd (NBD engine) support"=0A=
>>> +  echo "--disable-libzbc        Disable libzbc even if found"=0A=
>>=0A=
>> The message could simply be "Disable libzbc support".=0A=
>>=0A=
>>>    echo "--disable-tcmalloc	Disable tcmalloc support"=0A=
>>>    echo "--enable-libaio-uring   Enable libaio emulated over io_uring"=
=0A=
>>>    echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"=
=0A=
>>> @@ -2454,9 +2457,6 @@ fi=0A=
>>>=0A=
>>>  ##########################################=0A=
>>>  # libzbc probe=0A=
>>> -if test "$libzbc" !=3D "yes" ; then=0A=
>>> -  libzbc=3D"no"=0A=
>>> -fi=0A=
>>>  cat > $TMPC << EOF=0A=
>>>  #include <libzbc/zbc.h>=0A=
>>>  int main(int argc, char **argv)=0A=
>>> @@ -2466,19 +2466,21 @@ int main(int argc, char **argv)=0A=
>>>    return zbc_open("foo=3Dbar", O_RDONLY, &dev);=0A=
>>>  }=0A=
>>>  EOF=0A=
>>> -if compile_prog "" "-lzbc" "libzbc"; then=0A=
>>> -  libzbcvermaj=3D$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[=
0-=0A=
>> 9]*//')=0A=
>>> -  if test "$libzbcvermaj" -ge "5" ; then=0A=
>>> -    libzbc=3D"yes"=0A=
>>> +if test "$libzbc" !=3D "no" ; then=0A=
>>=0A=
>> If you make this:=0A=
>>=0A=
>> if test "$libzbc" =3D "yes" ; then=0A=
>>=0A=
>>> +  if compile_prog "" "-lzbc" "libzbc"; then=0A=
>>> +    minimum_libzbc=3D5=0A=
>>> +    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then=
=0A=
>>> +      libzbc=3D"yes"=0A=
>>> +    else=0A=
>>> +      print_config "libzbc engine" "libzbc version $minimum_libzbc or =
above=0A=
>> required"=0A=
>>> +      libzbc=3D"no"=0A=
>>> +    fi=0A=
>>=0A=
>> then you can simplify the above by reversing the if condition,=0A=
>>=0A=
>>>    else=0A=
>>> -    print_config "libzbc engine" "Unsupported libzbc version (version =
5 or=0A=
>> above required)"=0A=
>>> +    if test "$libzbc" =3D "yes" ; then=0A=
>>=0A=
>> and you do not need this if. Note that I think you need to initialize th=
e libzbc=0A=
>> variable to "yes" by default for this to work.=0A=
>>=0A=
> =0A=
> Right now, there is no default for libzbc ioengine support. If libzbc is =
found by=0A=
> configure, then libzbc ioengine will always be added. The new flag, --dis=
able-libzbc,=0A=
> prevents adding support for libzbc ioengine in this case. If libzbc is no=
t present,=0A=
> fio configure is not failed with "feature not found".=0A=
> =0A=
> Currently, no other feature in fio configure has the default option of "y=
es" and all=0A=
> features that can be explicitly set to yes are set so by script command l=
ine options.=0A=
> If a feature is set to yes and is not available, configure fails with "fe=
ature not found"=0A=
> error. Do we really want configure to fail on any system that doesn't hav=
e libzbc=0A=
> unless --disable-libzbc is added to the command line?=0A=
> =0A=
> There is one feature option, "disable_lex",  with the default value, "". =
I guess we=0A=
> could define libzbc option the same way to improve code clarity.=0A=
=0A=
Yes. That matches what Sitsofe commented too. That would mean, enable is fo=
und=0A=
if --disable-libzbc is not set, but do not fail configure if not found.=0A=
=0A=
> =0A=
>>> +      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"=0A=
>>> +    fi=0A=
>>>      libzbc=3D"no"=0A=
>>>    fi=0A=
>>> -else=0A=
>>> -  if test "$libzbc" =3D "yes" ; then=0A=
>>> -      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"=0A=
>>> -  fi=0A=
>>> -  libzbc=3D"no"=0A=
>>>  fi=0A=
>>>  print_config "libzbc engine" "$libzbc"=0A=
>>>=0A=
>>>=0A=
>>=0A=
>>=0A=
>> --=0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

