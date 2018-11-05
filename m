Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.gydle.com ([64.18.173.180]:50929 "EHLO mail.gydle.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbeKFAUq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 5 Nov 2018 19:20:46 -0500
Subject: Re: Mention of fio by Apple
References: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
From: Sebastien Boisvert <sboisvert@gydle.com>
Message-ID: <944db5fc-9ba8-870c-8e9d-50ff3d42bdd2@gydle.com>
Date: Mon, 5 Nov 2018 10:00:36 -0500
MIME-Version: 1.0
In-Reply-To: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>



On 2018-11-04 5:44 a.m., Sitsofe Wheeler wrote:
> Looks like someone is referencing an fio benchmark result on Apple's
> Mac Mini page and whoever did it took care to respect the Moral
> License (https://fio.readthedocs.io/en/latest/fio_doc.html#moral-license
> ). From https://www.apple.com/mac-mini/ :
> 
> "4. Testing conducted by Apple in October 2018 using preproduction
> 3.2GHz 6-core Intel Core i7-based Mac mini systems with 64GB of RAM
> and 1TB SSD, and shipping 3.0GHz dual-core Intel Core i7-based Mac
> mini systems with 16GB of RAM and 1TB SSD. Tested with FIO 3.8, 1024KB
> request size, 150GB test file and IO depth=8. Performance tests are
> conducted using specific computer systems and reflect the approximate
> performance of Mac mini."
> 
> My only question is: as the depth was 8 were they using the posixaio engine?
> 

The foot note number 4 supports this claim:

    "Up to 4X faster read speed"

It would make sense to use asynchronous I/O since ioengine=psync is the default on Mac.


