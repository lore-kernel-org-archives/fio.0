Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhEZTgS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 May 2021 15:36:18 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F6C061574
        for <fio@vger.kernel.org>; Wed, 26 May 2021 12:34:45 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id a5so3573539lfm.0
        for <fio@vger.kernel.org>; Wed, 26 May 2021 12:34:44 -0700 (PDT)
Received: from [192.168.1.19] (77-121-228-123.kra.volia.net. [77.121.228.123])
        by smtp.gmail.com with ESMTPSA id k8sm2246876lfg.190.2021.05.26.12.34.41
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 12:34:42 -0700 (PDT)
From: Professor Pro <annivation@gmail.com>
Subject: Can we build fio statically with both libaio and posixaio?
Message-ID: <26482be0-75b2-ab35-e217-94cbc39a0171@gmail.com>
Date: Wed, 26 May 2021 22:34:41 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I'm missing reason why fio can not be built statically with both libaio 
and posixaio

Here is simplest way to reproduce on clear linux using docker ubuntu image:

echo '
url=https://brick.kernel.dk/snaps/fio-3.26.tar.gz
libaio=https://pagure.io/libaio/archive/libaio-0.3.112/libaio-libaio-0.3.112.tar.gz
apt-get update
apt-get install libc6-dev build-essential autoconf autoconf make wget -y -q
work=/build/fio-src
mkdir -p $work
rm -rf $work/*
cd $work
rm -rf $work/*
wget -q -nv --no-check-certificate -O _fio.tgz $url
wget -q -nv --no-check-certificate -O _libaio.tgz $libaio
tar xzf _fio.tgz
rm -f _fio.tgz
tar xzf _libaio.tgz
rm -f _libaio.tgz

# build libaio
cd lib*
make prefix=/usr/local install
cd ../fio*

# build fio
./configure --prefix=/usr/local --build-static | tee configure.log
make -j && make install && echo "SUCCESS. $(fio --version) engines:" && 
fio --enghelp | tail -n +2 | sort
cat configure.log | grep "AIO"
' > /tmp/reproduce-missing-posixaio.sh
time docker run -t --rm 
-v/tmp/reproduce-missing-posixaio.sh:/tmp/reproduce-missing-posixaio.sh 
ubuntu:20.04 bash /tmp/reproduce-missing-posixaio.sh

OUTPUT is
SUCCESS. fio-3.26 engines:
         cpuio
         e4defrag
         falloc
         filecreate
         filestat
         ftruncate
         io_uring
         libaio
         mmap
         mtd
         net
         netsplice
         null
         psync
         pvsync
         pvsync2
         sg
         splice
         sync
         vsync
Linux AIO support             yes
Linux AIO support rw flags    yes
POSIX AIO support             no
POSIX AIO support needs -lrt  no
POSIX AIO fsync               no
Solaris AIO support           no


According to man [https://man7.org/linux/man-pages/man7/aio.7.html] 
posix aio was introduced in glibc 2.1.
Another words, libc6-dev 2.31 is preinstalled but posixaio is not 
available for static build?

Can we build fio statically with both libaio and posixaio?

Thanks in advance
Vlad


