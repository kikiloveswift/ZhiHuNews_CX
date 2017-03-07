//
//  ViewController.m
//  ZhiHuNews
//
//  Created by konglee on 2017/3/7.
//  Copyright © 2017年 陈鑫. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIWebView *_webView;
    BOOL firstLoad;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}


- (void)initUI
{
    NSString *bodyStr = @"<div class=\"main-wrap content-wrap\">\n<div class=\"headline\">\n\n\n<h1 class=\"headline-title onlyheading\">家庭的生命周期：关于「离家」<\/h1>\n\n\n\n\n<\/div>\n\n<div class=\"content-inner\">\n\n\n\n<div class=\"question\">\n<h2 class=\"question-title\">家庭科普系列.家庭生命周期：离家<\/h2>\n<div class=\"answer\">\n\n<div class=\"meta\">\n<img class=\"avatar\" src=\"http:\/\/pic4.zhimg.com\/c0081b6489e259e48562142c6320a2e7_is.jpg\">\n<span class=\"author\">冼艺哲，<\/span><span class=\"bio\">婚姻与家庭治疗师<\/span>\n<\/div>\n\n<div class=\"content\">\n<h3>家庭科普系列<\/h3><h2>家庭生命周期：离家<\/h2><p>在大学毕业的那几年，总有一些密切的朋友在讨论自己的前途、家庭，透露出他们的无奈。其中有两位同学的话让我印象最深刻：<\/p><p>“从小，我就是那种很独立的孩子。平时的事情我都能自己摆平自己决定。但在一些大事上，尤其是决定方向的事上，我虽然有自己的主意，但我也很希望爸爸妈妈能给意见我，和我商量。我会主动去跟他们谈，有时候他们也会问我。只是很多时候，这种沟通都很受挫。似乎他们并不明白我的想法，我也不能赞同他们的想法。慢慢我也放弃和他们谈了，因为不想有冲突。”<\/p><p>另一位朋友，则有完全不一样的感受：<\/p><p>“我是家中的小儿子。我觉得自己是比较简单的人，好好读书、好好工作，听爸妈的话。我才发现原来，父母给我灌输的价值观，我都全盘接收了，没有怀疑过。把爸爸妈妈的想法当作自己的目标。后来，我越来越质疑他们的判断，我也有了一些自己的想法，然后我突然感觉很厌恶，感觉他们似乎在控制我。然后我就开始反抗、摆脱他们的控制，很抵触他们，开始回避他们。但是我也知道这样不对……”<\/p><p>这两位朋友在谈起与父母的关系的时候几度哽咽。<strong>他们之间的关系纠结又敏感，既爱又害怕。他们其实都能感受到父母内心对他们最真挚最朴实的爱，但在互相靠近的时候，又被彼此所伤<\/strong>。从一个面上去看，这似乎是两个人表达技巧的问题，其实，这类型的问题，并不仅仅是一种沟通问题、代沟问题……<\/p><p>今天我给大家介绍另一个角度去看这类问题：家庭生命周期。对于一个家庭而言，以美国中产阶级为例，他们将会经历以下6个阶段，当然不是每个家庭都要完整地经历完6个阶段。<\/p><ul><li>成年的年轻人离开家庭，精神和生活独立；<\/li><li>新婚：结婚组成新家庭；<\/li><li>初为父母：拥有年幼孩子的家庭；<\/li><li>青春期：孩子步入青春期，家庭系统转变；<\/li><li>离巢：孩子离家，父母放手让孩子独立，继续自己的生活；<\/li><li>晚年：成为祖父母<\/li><\/ul><br><p>这是一个轮回。我们所有的人，都不仅仅是一个个体，而是在不同的阶段，处于不同的系统角色。现在你所在的周期，就是20年前甚至30年前，你的父母所处在的周期。而你的父母所处在的周期，就是20年后甚至30年后你将要经历的周期。<\/p><p>周期的更迭，变化的除了年龄，更关键的是角色的变换。意味着需求、想法、考虑的事情、决策的出发点都会有所改变。<\/p><p>在孩子刚出生的时候，他需要父母的全方位照顾。经历过的父母就能够深深地感受到那种什么都要为孩子担心，为孩子做，为孩子打算的感受。这个时期的孩子与父母的关系是很典型的粘连（Fuse）关系，这时候，孩子的情绪、行为受父母的影响很大，精神与生活都与父母息息相关。<\/p><p>孩子在年幼阶段一个非常典型的特质：自我中心。这正是与父母关系粘连（Fuse）的表现。父母与子女的情绪联动非常大。<\/p><br><p>在孩子成长的时候，有些父母看得远一些，会计划如何培养孩子变得独立、性格乐观等等，有些父母偏重于现在对孩子的照顾，有些父母关注于孩子现阶段与同龄人的竞争。虽然在教育和目的都大有不同，但都有一个共同点，就是他们在处理孩子的问题、教育孩子的时候，是从“什么样的教育是对的？怎样做好父母的角色？”的角度出发的，这就是父母的角度。<\/p><p>另外，再和大家分享一个很有意思的现象：在美国，家族里有一个很微妙的默契，往往祖父的离家年龄、爸爸的离家年龄、儿子的离家年龄会出奇地接近，他们结婚、生孩子的年龄也非常接近。<\/p><p>这和一个想法有非常大的关系，就是：父母在养育孩子的时候，判断孩子处于哪一个发展阶段，该做些什么，会参考自己成长、发展的轨迹，并把自己的轨迹作为参照物。<\/p><p>这一点在中国虽然也有发生，但没有美国明显。然而在中国又有另一个突出的问题：晚婚晚育与父母逼婚。也许与中国近年社会、舆论、文化、包容度与教育周期变化太大有非常大的关系。在父母已经结婚生子的年龄，我们这一辈的人还在读书，本科，或者研究生，甚至博士。初婚年龄大大滞后。长辈在这个状况下有可能不知道该如何应对，所以有了读书不准谈恋爱，毕业出来催结婚的闹剧。<\/p><p>从孩子的角度出发看，家庭生命周期的更迭，其实是孩子的成长与发展推动的，从依赖到独立，孩子对家长的需求的变化，对成长空间的需求越来越大，就是推动父母与孩子之间相处方式改变、角色改变的原动力。而这个关系，则是从婴儿、幼年时期的粘连（Fuse）状态，往独立，就是有自己的观点、看法，有自己的目标和发展打算、标准，有能力照顾自己、在社会上生存，并且为组成新家庭作准备。<\/p><p>就这样，很奇妙地，<strong>父母与孩子有不同的视角与出发点，一起去进行同一件事情。所以冲突与不同步是非常正常的<\/strong>。<\/p><p>这个过程的发生，对于大多数家庭来说，就是一个磕磕碰碰、有喜悦、有痛苦、有阵痛、有挣扎，虽然有很多问题，但还是能够顺利完成的过程，即是孩子学会了独立生活与发展，能够顺利建立自己的生活，父母能意识到孩子长大，有些事情他们自己能够处理，他们有自己的想法与目标，他们是与自己一样，是成年人，并且大家有新的相处默契。这是一个形成生命目标、成就“自我”的时期。<\/p><p>那些喜与悲、哀与乐，那些反复与纠缠，还有豁然开朗的顿悟，都是很正常，甚至是必然存在的。当一家人都开始思考：成年后，如何平衡独立和孝顺父母？这个问题的时候，就说明这个家庭正在朝一个好的方向在摸索。<\/p><p>但也存在一些家庭，他们不能顺利地完成这些周期的更迭。在“离家”这一个周期的不能顺利离家的青年人，他们往往与家庭处于两种很极端的状态：极端的回避、鼓励，切断与父母情感联系（Cut－off），或者是极端的粘连（Fuse），缺乏自我。就像开头我第二个同学的心声，他因为害怕这种过度粘连，失去自我，所以选择了逃避与不联系，因为每次联系每次冲突，对他的情绪影响都非常大。<\/p><p>选择与父母切断情感联系的孩子，往往都是从极度粘连的状态下出逃的，是单方面的选择。但往往选择切断与父母感情联系的青年人，他对这个家的感情，更是复杂，这个家对他而言，更是至关重要。在这种情况下，家庭治疗能很好地帮助在家庭生命周期中“脱轨的”的家庭重新回到正常发展的轨迹，进而解决很多由此衍生出来千奇百怪的表征问题。<\/p><p>离家到底是什么样的过程，可能每个人都不一样。无论是过程，还是终点。这不纯粹是一个任务，而是生命的故事。<\/p>\n\n<div class=\"view-more\"><a href=\"http:\/\/zhuanlan.zhihu.com\/p\/20160878\">查看知乎讨论<\/a><\/div>\n\n<\/div>\n<\/div>\n<\/div>\n\n\n<\/div>\n<\/div>";
    NSString* formatString = [NSString stringWithFormat:
                              @"<!DOCTYPE html><html><head lang=\"zh\"><meta charset=\"UTF-8\"> <link rel=\"stylesheet\" type=\"text/css\" href=\"http://news-at.zhihu.com/css/news_qa.auto.css?v=4b3e3\">"
                              "<body>"
                              "<p>%@</p>"
                              "</body></html>", bodyStr];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadHTMLString:formatString baseURL:nil];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://daily.zhihu.com/story/7097426"]]];
    
//    _webView.navigationDelegate = self;
//    _webView.UIDelegate = self;
//    NSString *jsString = @"localStorage.setItem('hideDownloadBanner', 'true')";
//    [_webView evaluateJavaScript:jsString completionHandler:nil];
    [self.view addSubview:_webView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 80, 50);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnAction
{
    [_webView reload];
}

//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    NSString *jsString = @"localStorage.setItem('hideDownloadBanner', 'true')";
//    [_webView evaluateJavaScript:jsString completionHandler:nil];
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    
////    NSString * userContent = [NSString stringWithFormat:@"{\"token\": \"%@\", \"userId\": %@}", @"a1cd4a59-974f-44ab-b264-46400f26c849", @"89"];
//    // 设置localStorage
////    NSString *jsString = @"localStorage.setItem('hideDownloadBanner', 'true')";
////    [_webView evaluateJavaScript:jsString completionHandler:nil];
////    if (firstLoad )
////    {
////    }
////    else
////    {
////        [webView reload];
////        firstLoad = YES;
////    }
//    
//    // 移除localStorage
//    // NSString *jsString = @"localStorage.removeItem('userToken')";
//    // 获取localStorage
//    // NSString *jsString = @"localStorage.getItem('userToken')";
//    // 设置localStorage
////    NSString *jsString = @"localStorage.setItem('hideDownloadBanner')";
//    // 移除localStorage
//    // NSString *jsString = @"localStorage.removeItem('userToken')";
//    // 获取localStorage
//    // NSString *jsString = @"localStorage.getItem('userToken')";
//}

@end
