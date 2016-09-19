Return-Path: <nadumutlusunil@gmail.com>
MIME-Version: 1.0
In-Reply-To: <602fc719-1c9e-74a4-f968-b0995957467b@kernel.dk>
References: <CAE5BwqHyQzTx7gtGMXb7wE1xvysxeiopsCBijSHEzOx29PvzHg@mail.gmail.com>
 <f78587ff-29be-aeee-29e3-4f08873701c7@kernel.dk> <602fc719-1c9e-74a4-f968-b0995957467b@kernel.dk>
From: Sunil Nadumutlu <nadumutlusunil@gmail.com>
Date: Mon, 19 Sep 2016 16:09:21 -0700
Message-ID: <CAE5BwqFbXuBvcM0Yk-1NMy=EHK2bMUo3orpi=nH+BwdMfiEOLQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_Unaligned_zoned_write_with_bsrange_=E2=80=983k=2D1025K?=
	=?UTF-8?Q?=E2=80=99_always_fails_for_the_reason_being_=E2=80=98data_corruption=E2=80=99?=
Content-Type: multipart/alternative; boundary=001a113982fafdd547053ce4666d
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a113982fafdd547053ce4666d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Sure Jens. will update mailing list on my findings.
Appreciate your time.
Regards,
Sunil


On Mon, Sep 19, 2016 at 2:09 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/19/2016 02:52 PM, Jens Axboe wrote:
>
>> On 09/19/2016 06:30 AM, Sunil Nadumutlu wrote:
>>
>>> Hi Jens,
>>>
>>> I have been observing one interesting issue since couple of days where
>>> write_verify is failing (due to data corruption) while running unaligne=
d
>>> zoned write with bsrange =E2=80=983k-1025K=E2=80=99.
>>> I have following fio CLI syntax tried on RHEL 7.0 client, by involving
>>> raw device and filesystem on raw dev as well.
>>>
>>> Here are fio CLI syntax:
>>> Raw device IO:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>   fio  --runtime=3D43200  --filename=3D/dev/sdc --rw=3Drandrw
>>> --ioengine=3Dlibaio --direct=3D1 --time_based --verify=3Dmd5 --verify_d=
ump=3D1
>>> --verify_fatal=3D1 --threads=3D8 --zonesize=3D1m --zoneskip=3D1024
>>> --name=3Dzoning-unaligned-large --bsrange=3D3k-1025k --runtime=3D86400
>>>
>>> File system (ext4) IO:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> fio  --runtime=3D43200  --filename=3D/tmp/xyz/fio3  --rw=3Drandrw
>>> --ioengine=3Dlibaio --direct=3D1 --time_based --verify=3Dmd5 --verify_d=
ump=3D1
>>> --verify_fatal=3D1 --threads=3D8 --zonesize=3D1m --zoneskip=3D1024
>>> --name=3Dzoning-unaligned-large --bsrange=3D3k-1025k --runtime=3D86400
>>> --create_on_open=3D1 --filesize=3D500m
>>> --buffer_pattern=3D0x48656c6c6f776f746c64
>>>
>>> write_verify always failed within few seconds on filesystem, and
>>> write_verify failed on raw device within 2-3mins for the reason being
>>> data corruption observed during write verification.
>>> In case of raw dev, data mismatch was observed after 1K (sometiem it wa=
s
>>> across block), however incase FS, data corruption was observed across
>>> 3076 block.
>>>
>>> To narrow down the issue, I ran similar workload bs=3D3k ( no bsrange ,
>>> and only fixed block) IO using vdbench and medusa tool, where test have
>>> passed successfully. Hence I am thinking that this is not an issue with
>>> storage array. At this time, I am just curious to know whether fio has
>>> any known bug in this area. One thing to note here is that vdbench and
>>> medusa doesn=E2=80=99t have block zoneing and bsrange option. It is alw=
ays fixed
>>> block size with these tools.
>>>
>>> Attached herewith are dumps collected from above 2 tests=E2=80=A6
>>> File system fio dump:
>>> fio3.1390592.expected
>>> fio3.1390592.received
>>>
>>> Raw dev fio dump:
>>> sdc.3325952.expected
>>> sdc.3325952.received
>>>
>>> Anticipating your help in this regard.
>>>
>>
>> Please send questions to the fio mailing list, fio@vger.kernel.org. I
>> don't have time to answer all queries personally, plenty more people are
>> capable of doing that.
>>
>> That said, you have multiple threads writing to the same file or device
>> in both cases.
>>
>
> Actually, I take that back, looks like it's just a bad use case of
> 'thread' - it's a bool, so just 0/1 applies here. There's just one job
> running in your test case.
>
> Can you try and add experimental_verify=3D1 and see if that changes
> anything for you?
>
> --
> Jens Axboe
>
>

--001a113982fafdd547053ce4666d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sure Jens. will update mailing list on my findings.<div>Ap=
preciate your time.</div><div>Regards,</div><div>Sunil</div><div><br></div>=
</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Sep=
 19, 2016 at 2:09 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:ax=
boe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 09=
/19/2016 02:52 PM, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 09/19/2016 06:30 AM, Sunil Nadumutlu wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi Jens,<br>
<br>
I have been observing one interesting issue since couple of days where<br>
write_verify is failing (due to data corruption) while running unaligned<br=
>
zoned write with bsrange =E2=80=983k-1025K=E2=80=99.<br>
I have following fio CLI syntax tried on RHEL 7.0 client, by involving<br>
raw device and filesystem on raw dev as well.<br>
<br>
Here are fio CLI syntax:<br>
Raw device IO:<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
=C2=A0 fio=C2=A0 --runtime=3D43200=C2=A0 --filename=3D/dev/sdc --rw=3Drandr=
w<br>
--ioengine=3Dlibaio --direct=3D1 --time_based --verify=3Dmd5 --verify_dump=
=3D1<br>
--verify_fatal=3D1 --threads=3D8 --zonesize=3D1m --zoneskip=3D1024<br>
--name=3Dzoning-unaligned-large --bsrange=3D3k-1025k --runtime=3D86400<br>
<br>
File system (ext4) IO:<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
fio=C2=A0 --runtime=3D43200=C2=A0 --filename=3D/tmp/xyz/fio3=C2=A0 --rw=3Dr=
andrw<br>
--ioengine=3Dlibaio --direct=3D1 --time_based --verify=3Dmd5 --verify_dump=
=3D1<br>
--verify_fatal=3D1 --threads=3D8 --zonesize=3D1m --zoneskip=3D1024<br>
--name=3Dzoning-unaligned-large --bsrange=3D3k-1025k --runtime=3D86400<br>
--create_on_open=3D1 --filesize=3D500m<br>
--buffer_pattern=3D0x48656c6c6f7<wbr>76f746c64<br>
<br>
write_verify always failed within few seconds on filesystem, and<br>
write_verify failed on raw device within 2-3mins for the reason being<br>
data corruption observed during write verification.<br>
In case of raw dev, data mismatch was observed after 1K (sometiem it was<br=
>
across block), however incase FS, data corruption was observed across<br>
3076 block.<br>
<br>
To narrow down the issue, I ran similar workload bs=3D3k ( no bsrange ,<br>
and only fixed block) IO using vdbench and medusa tool, where test have<br>
passed successfully. Hence I am thinking that this is not an issue with<br>
storage array. At this time, I am just curious to know whether fio has<br>
any known bug in this area. One thing to note here is that vdbench and<br>
medusa doesn=E2=80=99t have block zoneing and bsrange option. It is always =
fixed<br>
block size with these tools.<br>
<br>
Attached herewith are dumps collected from above 2 tests=E2=80=A6<br>
File system fio dump:<br>
fio3.1390592.expected<br>
fio3.1390592.received<br>
<br>
Raw dev fio dump:<br>
sdc.3325952.expected<br>
sdc.3325952.received<br>
<br>
Anticipating your help in this regard.<br>
</blockquote>
<br>
Please send questions to the fio mailing list, <a href=3D"mailto:fio@vger.k=
ernel.org" target=3D"_blank">fio@vger.kernel.org</a>. I<br>
don&#39;t have time to answer all queries personally, plenty more people ar=
e<br>
capable of doing that.<br>
<br>
That said, you have multiple threads writing to the same file or device<br>
in both cases.<br>
</blockquote>
<br></div></div>
Actually, I take that back, looks like it&#39;s just a bad use case of<br>
&#39;thread&#39; - it&#39;s a bool, so just 0/1 applies here. There&#39;s j=
ust one job<br>
running in your test case.<br>
<br>
Can you try and add experimental_verify=3D1 and see if that changes<br>
anything for you?<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--001a113982fafdd547053ce4666d--

