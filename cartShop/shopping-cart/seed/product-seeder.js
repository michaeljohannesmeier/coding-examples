var Product = require('../models/product');

var mongoose = require('mongoose');

mongoose.connect('localhost:27017/shopping');


var products = [
    new Product({
        imagePath:'http://www.wigglestatic.com/product-media/5360108808/Wiggle-Road-Bike-Road-Bikes-Black-1WGMY16R7048UK0001-6.jpg?w=2000&h=2000&a=7g',
        title: "Wiggle Bike",
        descriptionShort: "A brand new Wiggle bike!!",
        descriptionLong: "The origins of the Wiggle trace back to a local bike shop called Butlers Cycles, located in Portsmouth. Mitch Dall, a founder of Wiggle, bought the shop in 1995.\n" +
        "\n" +
        "Wiggle started officially trading on 28th May 1999, with an initial investment of £2000 from Mitch Dall and Harvey Jones.\n" +
        "\n" +
        "Between 1999 and 2009, Wiggle experienced strong growth, and experimented with online retail.\n" +
        "\n" +
        "In 2009, Mitch Dall sold his 26 percent stake in the company to investment firm ISIS Equity Partners.[1]\n" +
        "\n" +
        "Humphrey Cobbold became CEO of Wiggle in 2009, with Andrew Bond, the former CEO of Asda, joining as the chair of the board of directors. Annual sales in 2009 were £55 million.\n" +
        "\n" +
        "By 2011, annual revenue was £86 million and ISIS considered taking the company public in an initial public offering,[2] with the company's overall value estimated at £200m,[3] and pre-tax profits having risen from £7.1m to £10.2m in the year to January 2011, following a 123 percent increase in international sales.[1]\n" +
        "\n" +
        "In December 2011, Wiggle was acquired by venture capitalists Bridgepoint Capital for £180m[4]. The investment from the new owners allowed Wiggle to launch 11 new websites for overseas consumers.\n" +
        "\n" +
        "In 2015, the company moved its warehouse from Portsmouth to a newer larger premise in Wolverhampton, and the offices moved to new premises at 1000 Lakeside, Portsmouth.\n" +
        "\n" +
        "In February 2016, the merger of Wiggle and Chain Reaction Cycles was announced[5]; combining the two largest companies in the UK online cycle retail market. The WiggleCRC group formed in July 2016, after the Competition Commission approved the merger.",
        price: 699
    }),
    new Product({
        imagePath:'http://www.svetmobilne.cz/svetmobilne/media.nsf/v/BEF390973F69EB10C1257CFA004B33F2/$file/star-n9500-170.jpg',
        title: "Samsung Galaxy S4",
        descriptionShort: "The brand new Samsung Galaxy S4!!",
        descriptionLong: "Samsung Galaxy is a series of mobile computing devices designed, manufactured and marketed by Samsung Electronics. The product line includes the Galaxy S series of high-end smartphones, the Galaxy Tab series of tablets, the Galaxy Note series of tablets and phablets with the added functionality of a stylus, and the first version of the Galaxy Gear smartwatch, with later versions dropping the Galaxy branding.\n" +
        "\n" +
        "Samsung Galaxy devices use the Android operating system produced by Google, usually with a custom user interface called Samsung Experience (formerly TouchWiz). However, the tradition of Android-exclusivity for the series was broken at CES 2016 with the announcement of the first Galaxy-branded Windows 10 device, the Samsung Galaxy TabPro S.[1]\n" +
        "\n" +
        "The S7, S8, S9, Note FE and Note8 Galaxy devices come with a file transfer app (Smart Switch) pre-loaded, with no app icon. Smart Switch works with all recent Galaxy devices, from the S2 through to current models.",
        price: 219
    }),
    new Product({
        imagePath:'https://www.teelicious.de/wp-content/uploads/Teelicious-Dresden-Neustadt.jpg',
        title: "Chinese Tea Set",
        descriptionShort: "Complete Chinese Tea Set!!",
        descriptionLong: "The accepted history[1] of the tea set begins in China during the Han Dynasty (206–220 BC). At this time, tea ware was made of porcelain and consisted of two styles: a northern white porcelain and a southern light blue porcelain. It is important to understand that these ancient tea sets were not the creamer/sugar bowl companions we know today. Rather, as is stated in a third-century AD written document from China, tea leaves were pressed into cakes or bricks. These patties were then crushed and mixed with a variety of spices, including orange, ginger, onions, and flower petals. Hot water was poured over the mixture, which was both heated and served in bowls, not teapots. The bowls were multi-purpose, and used for a variety of cooking needs. In this period, evidence suggests that tea was mainly used as a medicinal elixir, not as a daily drink for pleasure's sake.\n" +
        "\n" +
        "Historians believe the teapot was developed during the Song Dynasty (960–1279 AD) An archaeological dig turned up an ancient kiln that contained the remnants of a Yixing teapot. Yixing teapots, called Zi Sha Hu in China and Purple Sand teapots in the U.S., are perhaps the most famous teapots. They are named for a tiny city located in Jiangsu Province, where a specific compound of iron ore results in the unique coloration of these teapots. They were fired without a glaze and were used to steep specific types of oolong teas. Because of the porous nature of the clay, the teapot would gradually be tempered by using it for brewing one kind of tea. This seasoning was part of the reason to use Yixing teapots. In addition, artisans created fanciful pots incorporating animal shapes.\n" +
        "\n" +
        "The Song Dynasty also produced exquisite ceramic teapots and tea bowls in glowing glazes of brown, black and blue. A bamboo whisk was employed to beat the tea into a frothy confection highly prized by the Chinese.",
        price: 48
    }),
    new Product({
        imagePath:'http://www.lynnmaudlin.com/images/dragon-teapot.png',
        title: "Chinese Tea Cup",
        descriptionShort: "A beautiful chinese tee cup!!",
        descriptionLong: "A teacup is a cup, with or without a handle, generally a small one that may be grasped with the thumb and one or two fingers. In some lands it is custom to raise the last finger on the hand, or \"pinkie\" when drinking from a tea cup. It is typically made of a ceramic material. It is usually part of a set, composed of a cup and a matching saucer or a trio that includes a small cake or sandwich plate. These in turn may be part of a tea set in combination with a teapot, cream jug, covered sugar bowl and slop bowl en suite. Teacups are often wider and shorter than coffee cups. Cups for morning tea are conventionally larger than cups for afternoon tea.\n" +
        "\n" +
        "Better teacups typically are of fine white translucent porcelain and decorated with patterns that may be en suite with extensive dinner services. Some collectors acquire numerous one-of-a-kind cups with matching saucers. Such decorative cabinet cups may be souvenirs of a location, person, or event. Such collectors may also accumulate silver teaspoons with a decorated enamel insert in the handle, with similar themes.\n" +
        "\n" +
        "In the culture of China teacups are very small, normally holding no more than 30ml of liquid. They are designed to be used with Yixing teapots or Gaiwan.[1] Countries in the Horn of Africa like Eritrea also use the handleless cups to drink boon which is traditional coffee there. In Russian-speaking cultures and West Asian cultures influenced by the Ottoman Empire tea is often served in a glass held in a separate metal container with a handle, called a zarf. or in Russian a podstakannik.\n" +
        "\n" +
        "The first small cups specifically made for drinking the beverage tea when it was newly seen in Europe in the 17th century were exported from the Japanese port of Imari or from the Chinese port of Canton. Tea bowls in the Far East did not have handles, and the first European imitations, made at Meissen, were without handles, too. At the turn of the 19th century canns of cylindrical form with handles became a fashionable alternative to bowl-shaped cups.",
        price: 12
    }),

];

var done=0;

for (var i=0; i < products.length; i++) {
    products[i].save(function(err, result){
        done++;
        if (done === products.length){
            exit();
        }
    });
}

function exit() {
    mongoose.disconnect();
}






