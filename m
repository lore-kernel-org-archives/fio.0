Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:35505 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbeJZXah (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Oct 2018 19:30:37 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: fio on vmware esxi
From: Eliezer Nebab <eliezer@integritech.solutions>
In-Reply-To: <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com>
Date: Fri, 26 Oct 2018 09:53:10 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <C7097D32-CB26-49DF-BA3C-A52EAA5A361F@integritech.solutions>
References: <001001d460c6$8c44b090$a4ce11b0$@integritech.solutions> <BC19FF62-2BD8-4F83-9BFB-8D271F5D7101@emc.com> <AE78B431-F6A6-4796-BB7E-1FE45E328D74@integritech.solutions> <0DE2B6A6-1AFB-4FAD-BD99-53136B45BCD8@emc.com> <CALjAwxjazAUEip=nea=7K8LVRBRwq6c0h9FheeCVvh372ZvaKw@mail.gmail.com> <6E7254E9-4B9B-4208-9392-2ABD43FE36A4@emc.com> <555423228.215547.1540355274473@email.1and1.com> <CALjAwxi5T_p5JTpRfazPcV1KoeKNm0CnO9ffBKAtCBCAMhA5=w@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Mark Beierl <Mark.Beierl@dell.com>, fio <fio@vger.kernel.org>

posixaio engine worked!

Thank you very much Sitsofe and Mark im good to go!



> On Oct 24, 2018, at 12:05 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> 
> lHi,
> 
> If you don't need asynchrony pvsync2 tends to be good. If you do I
> think the only choice from the engines listed is posixaio...
> 
> Regarding libaio, see my earlier reply to Mark...
> 
> PS: VMware is spelt with a lowercase w - http://thelowercasew.com/about .
> 
> On Wed, 24 Oct 2018 at 05:27, Eliezer Nebab
> <eliezer@integritech.solutions> wrote:
>> 
>> Mark,
>> 
>> 
>> Finally had a chance to try this out this weekend.
>> 
>> 
>> VMWare version:
>> 
>> # vmware -v
>> VMware ESXi 6.5.0 build-8294253
>> 
>> 
>> I built the docker file per your procedure, but I excluded the line that Sitsofe mentioned ("RUN git config --global http.sslVerify false") and started docker exactly the way you described.
>> 
>> I then copied the ID:
>> 
>> # docker cp 997cd757e1f1d350e353bd6b4a252c5b16497e49d0b4ed46e32273dc 6a82aa56:/fio/fio .
>> # ls -l
>> total 5832
>> -rw-r--r--. 1 root root 341 Oct 23 22:39 Dockerfile
>> -rwxr-xr-x. 1 root root 5951600 Oct 23 22:46 fio
>> 
>> 
>> I scp'd the "fio" file to my esxi server.
>> 
>> To my excitement, tried to run "fio" with the libaio which did not work.  The only engines available out of that fio build are as follows:
>> 
>> /tmp/fio --enghelp
>> 
>> 
>> Available IO engines:
>> cpuio
>> mmap
>> sync
>> psync
>> vsync
>> pvsync
>> pvsync2
>> null
>> net
>> netsplice
>> ftruncate
>> filecreate
>> posixaio
>> falloc
>> e4defrag
>> splice
>> mtd
>> sg
>> 
>> Otherwise, fio is working just as you described.   Thank you very much Mark!!!
>> 
>> So, out of the engines listed above, which ioengine would be suitable to use for VMWare testing?
> 
> -- 
> Sitsofe | http://sucs.org/~sits/


