Return-Path: <wcline@us.ibm.com>
In-Reply-To: <CAPWDiB1nNqDz8i7r=TvUNfqk3HBsA4vnqks5irnWUuS0vgi3yw@mail.gmail.com>
References: <CAPWDiB2yMrTVbAGiPKN_B4mLU=sL7W1_9Xw7OVM2Or7TDJGXPA@mail.gmail.com>	<50182E8F.8090006@kernel.dk> <CAPWDiB1nNqDz8i7r=TvUNfqk3HBsA4vnqks5irnWUuS0vgi3yw@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: fio with fallocate fails with ENOSYS
Message-ID: <OF28F1B9FE.0515D98B-ON87257A4C.006B39F6-88257A4C.006B5C80@us.ibm.com>
From: Wade Cline <wcline@us.ibm.com>
Date: Tue, 31 Jul 2012 12:32:42 -0700
Content-Type: multipart/alternative; boundary="=_alternative 006B5C7E88257A4C_="
To: Kevin Castiglia <kcastiglia@aereo.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, cmm@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

This is a multipart message in MIME format.
--=_alternative 006B5C7E88257A4C_=
Content-Type: text/plain; charset="US-ASCII"

Hello,

I actually ran into this issue as well and made a patch for it, though I 
seem to have sent the e-mail to the incorrect address. I'll re-submit it 
real quick...

Thank you,
Wade Cline



From:   Kevin Castiglia <kcastiglia@aereo.com>
To:     Jens Axboe <axboe@kernel.dk>, 
Cc:     fio@vger.kernel.org
Date:   07/31/2012 12:30 PM
Subject:        Re: fio with fallocate fails with ENOSYS
Sent by:        fio-owner@vger.kernel.org



On Tue, Jul 31, 2012 at 3:14 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-07-12 22:51, Kevin Castiglia wrote:
>> Hello,
>>
>> fio with fallocate fails with ENOSYS, but I'm unable to reproduce this
>> failure outside of fio. The following command:
>>     fio --rw=write --fallocate=keep --filename=hello --size=1G
>> --runtime=10 --time_based --name=test
>> reports an error (if there is no file named 'hello' in my current
>> working directory).
>>
>> Within the output I see: err=38 (file:filesetup.c:98, func=fallocate,
>> error=Function not implemented)
>>
>> The following C program prints 0 (if there is no file named testing in
>> my current working directory):
>>
>> #include <linux/falloc.h>
>> #include <stdio.h>
>> #include <errno.h>
>>
>> int main() {
>>
>>     int f = open("testing", "O_CREAT", "0644");
>>     int r = fallocate(f, 01, 0, 1073741824);
>>     printf("%d\n", r);
>>
>> }
>>
>> Why is the fio command above failing with ENOSYS when this test
>> program runs without errors?
>>
>> Also,
>>
>>     $ strace fallocate -n -l 1G test
>>     ...
>>     fallocate(3, 01, 0, 1073741824)         = 0
>>     ...
>>
>> the fallocate system call seems to work.
>>
>> I'm using Fedora 16 , fio 2.07, and an ext4 filesystem
>>
>>     $ fio --version
>>     fio 2.0.7
>>
>>     $ uname -r
>>     3.1.0-7.fc16.x86_64
>>
>>     $ mount
>>     ...
>>     /dev/mapper/vg_kcastiglia-lv_home on /home type ext4
>> (rw,relatime,seclabel,user_xattr,acl,barrier=1,data=ordered)
>>     ...
>>
>>     $ ldd --version
>>     ldd (GNU libc) 2.14.90
>>     ...
>>
>>     $ gcc --version
>>     gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
>>     ...
>
> It'd help if you strace (-f) fio to show the issue.
>
> --
> Jens Axboe
>

I've attached the output of strace -f fio --rw=write --fallocate=keep
--filename=hello --size=1G --runtime=10 --time_based --name=test

Hope this helps,
  Kevin Castiglia
[attachment "strace_output.log" deleted by Wade Cline/Beaverton/IBM] 

--=_alternative 006B5C7E88257A4C_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">Hello,<br>
<br>
I actually ran into this issue as well and made a patch for it, though
I seem to have sent the e-mail to the incorrect address. I'll re-submit
it real quick...<br>
<br>
Thank you,<br>
Wade Cline</font>
<br>
<br>
<br>
<br><font size=1 color=#5f5f5f face="sans-serif">From: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">Kevin Castiglia &lt;kcastiglia@aereo.com&gt;</font>
<br><font size=1 color=#5f5f5f face="sans-serif">To: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">Jens Axboe &lt;axboe@kernel.dk&gt;,
</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Cc: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">fio@vger.kernel.org</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Date: &nbsp; &nbsp; &nbsp;
&nbsp;</font><font size=1 face="sans-serif">07/31/2012 12:30 PM</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Subject: &nbsp; &nbsp;
&nbsp; &nbsp;</font><font size=1 face="sans-serif">Re: fio with
fallocate fails with ENOSYS</font>
<br><font size=1 color=#5f5f5f face="sans-serif">Sent by: &nbsp; &nbsp;
&nbsp; &nbsp;</font><font size=1 face="sans-serif">fio-owner@vger.kernel.org</font>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=2>On Tue, Jul 31, 2012 at 3:14 PM, Jens Axboe &lt;axboe@kernel.dk&gt;
wrote:<br>
&gt; On 2012-07-12 22:51, Kevin Castiglia wrote:<br>
&gt;&gt; Hello,<br>
&gt;&gt;<br>
&gt;&gt; fio with fallocate fails with ENOSYS, but I'm unable to reproduce
this<br>
&gt;&gt; failure outside of fio. The following command:<br>
&gt;&gt; &nbsp; &nbsp; fio --rw=write --fallocate=keep --filename=hello
--size=1G<br>
&gt;&gt; --runtime=10 --time_based --name=test<br>
&gt;&gt; reports an error (if there is no file named 'hello' in my current<br>
&gt;&gt; working directory).<br>
&gt;&gt;<br>
&gt;&gt; Within the output I see: err=38 (</font></tt><a href=file://filesetup.c:98><tt><font size=2>file:filesetup.c:98</font></tt></a><tt><font size=2>,
func=fallocate,<br>
&gt;&gt; error=Function not implemented)<br>
&gt;&gt;<br>
&gt;&gt; The following C program prints 0 (if there is no file named testing
in<br>
&gt;&gt; my current working directory):<br>
&gt;&gt;<br>
&gt;&gt; #include &lt;linux/falloc.h&gt;<br>
&gt;&gt; #include &lt;stdio.h&gt;<br>
&gt;&gt; #include &lt;errno.h&gt;<br>
&gt;&gt;<br>
&gt;&gt; int main() {<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; int f = open(&quot;testing&quot;, &quot;O_CREAT&quot;,
&quot;0644&quot;);<br>
&gt;&gt; &nbsp; &nbsp; int r = fallocate(f, 01, 0, 1073741824);<br>
&gt;&gt; &nbsp; &nbsp; printf(&quot;%d\n&quot;, r);<br>
&gt;&gt;<br>
&gt;&gt; }<br>
&gt;&gt;<br>
&gt;&gt; Why is the fio command above failing with ENOSYS when this test<br>
&gt;&gt; program runs without errors?<br>
&gt;&gt;<br>
&gt;&gt; Also,<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ strace fallocate -n -l 1G test<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;&gt; &nbsp; &nbsp; fallocate(3, 01, 0, 1073741824) &nbsp; &nbsp; &nbsp;
&nbsp; = 0<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;&gt;<br>
&gt;&gt; the fallocate system call seems to work.<br>
&gt;&gt;<br>
&gt;&gt; I'm using Fedora 16 , fio 2.07, and an ext4 filesystem<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ fio --version<br>
&gt;&gt; &nbsp; &nbsp; fio 2.0.7<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ uname -r<br>
&gt;&gt; &nbsp; &nbsp; 3.1.0-7.fc16.x86_64<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ mount<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;&gt; &nbsp; &nbsp; /dev/mapper/vg_kcastiglia-lv_home on /home type
ext4<br>
&gt;&gt; (rw,relatime,seclabel,user_xattr,acl,barrier=1,data=ordered)<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ ldd --version<br>
&gt;&gt; &nbsp; &nbsp; ldd (GNU libc) 2.14.90<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; $ gcc --version<br>
&gt;&gt; &nbsp; &nbsp; gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)<br>
&gt;&gt; &nbsp; &nbsp; ...<br>
&gt;<br>
&gt; It'd help if you strace (-f) fio to show the issue.<br>
&gt;<br>
&gt; --<br>
&gt; Jens Axboe<br>
&gt;<br>
<br>
I've attached the output of strace -f fio --rw=write --fallocate=keep<br>
--filename=hello --size=1G --runtime=10 --time_based --name=test<br>
<br>
Hope this helps,<br>
 &nbsp;Kevin Castiglia<br>
[attachment &quot;strace_output.log&quot; deleted by Wade Cline/Beaverton/IBM]
</font></tt>
<br>
--=_alternative 006B5C7E88257A4C_=--


