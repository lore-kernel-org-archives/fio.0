Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:62191 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761334Ab3EADh6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Apr 2013 23:37:58 -0400
Received: by mail-vb0-f54.google.com with SMTP id q12so51826vbe.27
        for <fio@vger.kernel.org>; Tue, 30 Apr 2013 20:37:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKCZDg=h=Ggs-HKZUJxPyhXSZQJ0=meW2bGp0mm=O-2KQSZ48A@mail.gmail.com>
References: <372C7AE269BA5E4D92B1082F530ED4B85069DFC9@ORSMSX110.amr.corp.intel.com>
	<CAKCZDg=h=Ggs-HKZUJxPyhXSZQJ0=meW2bGp0mm=O-2KQSZ48A@mail.gmail.com>
Date: Wed, 1 May 2013 13:37:57 +1000
Message-ID: <CAKCZDgm5DxaqewpnqPGqoaUEE=W1_uvwMqDZ4AWFzvVyKKxv-g@mail.gmail.com>
Subject: Re: android ashmem patch [review request]
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 1 May 2013 13:34, Aaron Carroll <xaaronc@gmail.com> wrote:
> On 1 May 2013 08:04, Akers, Jason B <jason.b.akers@intel.com> wrote:
>> I wrapped the ashmem calls with the existing shm* function definitions. It's a little ugly, but makes for an easy patch touching only os/os-android.h.
>>
>> Tested on both arm and x86 android phones.
>>
>> [..]
>>
>>  static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
>>  {
>> -       return syscall(__NR_shmctl, __shmid, __cmd, __buf);
>> +       int ret=0;
>> +       if (__cmd == IPC_RMID)
>> +       {
>> +               int length = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
>> +               struct ashmem_pin pin = {0 , length};
>> +               ret = ioctl(__shmid, ASHMEM_UNPIN, &pin);
>
> I'm not sure that you want to make the region unpinned. How can we
> recover if the region is reclaimed?

Oops, didn't notice that was on the RMID path, ignore that.

  -- Aaron
