<!-- main menu -->
<ul id="<?= $id ?>" class="<?= $class ?>">

    <!-- menu item -->
    <li><a href="index.php" title="Some title 1">Home</a></li>

    <!-- menu item with submenu -->
    <li class="rm-submenu" >
        <a class="rm-submenu-button" href="#" title="Display submenu"></a>
        <a href="#" title="Some title 2">Test with submenu</a>

        <!-- sub item -->
        <ul>
            <!-- menu item -->
            <li><a href="index.php" title="Some item 1">Item 1</a></li>

            <!-- menu item with submenu -->
            <li class="rm-submenu" >
                <a class="rm-submenu-button" href="#" title="Display submenu"></a>
                <a href="#" title="Some title 2">Test with nested submenu</a>

                <!-- sub item -->
                <ul class="rm-submenu-level-1">
                    <!-- menu item -->
                    <li><a href="index.php" title="Some item 1">Item 1</a></li>

                    <!-- menu item -->
                    <li><a href="index.php" title="Some item 2">Item 2</a></li>

                    <!-- menu item -->
                    <li><a href="index.php" title="Some item 2">Item 3</a></li>
                </ul>
            </li>

            <!-- menu item -->
            <li><a href="index.php" title="Some item 2">Item 2</a></li>
        </ul>

    </li>

    <!-- menu item -->
    <li><a href="index.php" title="Some title 3">About</a></li>
</ul>
