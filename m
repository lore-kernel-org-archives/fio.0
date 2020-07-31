Return-Path: <prvs=474eabae4=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2 2/4] configure: check if pkg-config is installed
Date: Fri, 31 Jul 2020 07:06:02 +0000
Message-ID: 
 <MWHPR04MB375853F3B8B5906F9001BCEDE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
 <20200729210415.4166-3-dmitry.fomichev@wdc.com>
 <CY4PR04MB3751447CD156144A978738D3E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <MN2PR04MB5951014D567FC00446496FC4E1710@MN2PR04MB5951.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2020/07/31 8:10, Dmitry Fomichev wrote:=0A=
> =0A=
> =0A=
>> -----Original Message-----=0A=
>> From: Damien Le Moal <Damien.LeMoal@wdc.com>=0A=
>> Sent: Thursday, July 30, 2020 1:03 AM=0A=
>> To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>; Jens Axboe=0A=
>> <axboe@kernel.dk>=0A=
>> Cc: fio@vger.kernel.org; Shinichiro Kawasaki=0A=
>> <shinichiro.kawasaki@wdc.com>=0A=
>> Subject: Re: [PATCH v2 2/4] configure: check if pkg-config is installed=
=0A=
>>=0A=
>> On 2020/07/30 6:04, Dmitry Fomichev wrote:=0A=
>>> A few libraries need to be newer than a specific version in order to be=
=0A=
>>> supported by fio and pkg-config utility is used to verify the versions=
=0A=
>>> of the installed libraries. Since this step may fail because pkg-config=
=0A=
>>> is not installed, verify pkg-config presence and warn the user if it=0A=
>>> could not be found.=0A=
>>>=0A=
>>> To avoid code duplication, add a common helper function to perform=0A=
>>> these checks.=0A=
>>>=0A=
>>> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>=0A=
>>> ---=0A=
>>>  configure | 45 +++++++++++++++++++++++++--------------------=0A=
>>>  1 file changed, 25 insertions(+), 20 deletions(-)=0A=
>>>=0A=
>>> diff --git a/configure b/configure=0A=
>>> index 9a5f35f2..01fa5d1c 100755=0A=
>>> --- a/configure=0A=
>>> +++ b/configure=0A=
>>> @@ -133,6 +133,23 @@ output_sym() {=0A=
>>>    echo "#define $1" >> $config_host_h=0A=
>>>  }=0A=
>>>=0A=
>>> +check_min_lib_version() {=0A=
>>> +  local feature=0A=
>>> +=0A=
>>> +  if ${cross_prefix}pkg-config --atleast-version=3D$2 $1 > /dev/null 2=
>&1;=0A=
>> then=0A=
>>> +    return 0=0A=
>>> +  fi=0A=
>>> +  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then=0A=
>>> +    feature=3D${3:=3D$1}=0A=
>>> +    if test ${!feature} =3D "yes" ; then=0A=
>>> +      feature_not_found "" "$1 >=3D $2"=0A=
>>> +    fi=0A=
>>> +  else=0A=
>>> +    print_config "$1" "missing pkg-config, can't check library version=
"=0A=
>>> +  fi=0A=
>>> +  return 1=0A=
>>> +}=0A=
>>> +=0A=
>>>  targetos=3D""=0A=
>>>  cpu=3D""=0A=
>>>=0A=
>>> @@ -1520,18 +1537,17 @@ if test "$?" !=3D "0" ; then=0A=
>>>    echo "configure: gtk and gthread not found"=0A=
>>>    exit 1=0A=
>>>  fi=0A=
>>> -if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then=
=0A=
>>> -  echo "GTK found, but need version 2.18 or higher"=0A=
>>> -  gfio=3D"no"=0A=
>>> -else=0A=
>>> +gfio=3D"yes"=0A=
>>=0A=
>> I do not think adding this line is necessary. You can just keep the belo=
w=0A=
>> gfio=3D"yes" assignment, no ?=0A=
>>=0A=
>>> +if check_min_lib_version gtk+-2.0 2.18.0 "gfio"; then=0A=
>>>    if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then=0A=
>>> -    gfio=3D"yes"=0A=
>>>      GFIO_LIBS=3D"$LIBS $GTK_LIBS"=0A=
>>>      CFLAGS=3D"$CFLAGS $GTK_CFLAGS"=0A=
>>>    else=0A=
>>>      echo "Please install gtk and gdk libraries"=0A=
>>>      gfio=3D"no"=0A=
>>>    fi=0A=
>>> +else=0A=
>>> +  gfio=3D"no"=0A=
>>>  fi=0A=
>>>  LDFLAGS=3D$ORG_LDFLAGS=0A=
>>>  fi=0A=
>>> @@ -2181,15 +2197,11 @@ print_config "DDN's Infinite Memory Engine"=0A=
>> "$libime"=0A=
>>>  ##########################################=0A=
>>>  # Check if we have libiscsi=0A=
>>>  if test "$libiscsi" !=3D "no" ; then=0A=
>>> -  minimum_libiscsi=3D1.9.0=0A=
>>> -  if $(pkg-config --atleast-version=3D$minimum_libiscsi libiscsi); the=
n=0A=
>>> +  if check_min_lib_version libiscsi 1.9.0; then=0A=
>>>      libiscsi=3D"yes"=0A=
>>>      libiscsi_cflags=3D$(pkg-config --cflags libiscsi)=0A=
>>>      libiscsi_libs=3D$(pkg-config --libs libiscsi)=0A=
>>>    else=0A=
>>> -    if test "$libiscsi" =3D "yes" ; then=0A=
>>> -      feature_not_found "libiscsi" "libiscsi >=3D $minimum_libiscsi"=
=0A=
>>> -    fi=0A=
>>=0A=
>> Why do you remove this ? You only need to remove the "if" but should kee=
p=0A=
>> the=0A=
>> feature_not_found call.=0A=
> =0A=
> The feature_not_found call is now part of check_min_lib_version() functio=
n code.=0A=
> I think it is the right thing to do to avoid code duplication. Also, this=
 unifies the=0A=
> script behavior when an out of date library is found - the message in lib=
zbc case=0A=
> will be similar to libiscsi and libnbd.=0A=
=0A=
Missed that. You are right.=0A=
=0A=
> =0A=
>>=0A=
>>>      libiscsi=3D"no"=0A=
>>>    fi=0A=
>>>  fi=0A=
>>> @@ -2198,15 +2210,11 @@ print_config "iscsi engine" "$libiscsi"=0A=
>>>  ##########################################=0A=
>>>  # Check if we have libnbd (for NBD support)=0A=
>>>  if test "$libnbd" !=3D "no" ; then=0A=
>>> -  minimum_libnbd=3D0.9.8=0A=
>>> -  if $(pkg-config --atleast-version=3D$minimum_libnbd libnbd); then=0A=
>>> +  if check_min_lib_version libnbd 0.9.8; then=0A=
>>>      libnbd=3D"yes"=0A=
>>>      libnbd_cflags=3D$(pkg-config --cflags libnbd)=0A=
>>>      libnbd_libs=3D$(pkg-config --libs libnbd)=0A=
>>>    else=0A=
>>> -    if test "$libnbd" =3D "yes" ; then=0A=
>>> -      feature_not_found "libnbd" "libnbd >=3D $minimum_libnbd"=0A=
>>> -    fi=0A=
>>=0A=
>> Same here.=0A=
> =0A=
> I need to mention that this patch has been tested against all the four li=
braries affected.=0A=
> =0A=
>>=0A=
>>>      libnbd=3D"no"=0A=
>>>    fi=0A=
>>>  fi=0A=
>>> @@ -2468,11 +2476,8 @@ int main(int argc, char **argv)=0A=
>>>  EOF=0A=
>>>  if test "$libzbc" !=3D "no" ; then=0A=
>>>    if compile_prog "" "-lzbc" "libzbc"; then=0A=
>>> -    minimum_libzbc=3D5=0A=
>>> -    if $(pkg-config --atleast-version=3D$minimum_libzbc libzbc); then=
=0A=
>>> -      libzbc=3D"yes"=0A=
>>> -    else=0A=
>>> -      print_config "libzbc engine" "libzbc version $minimum_libzbc or =
above=0A=
>> required"=0A=
>>> +    libzbc=3D"yes"=0A=
>>> +    if ! check_min_lib_version libzbc 5; then=0A=
>>=0A=
>> OK. So my comment on the previous patch is addressed here. But I still d=
o=0A=
>> not=0A=
>> see an initialization of libzbc to "yes"=0A=
> =0A=
> Replied in the email for the other patch, the way it works now might actu=
ally be ok...=0A=
=0A=
Yes. Got it. But it may still be good to add the initialization libzbc=3D""=
.=0A=
=0A=
> =0A=
>>=0A=
>>>        libzbc=3D"no"=0A=
>>>      fi=0A=
>>>    else=0A=
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

