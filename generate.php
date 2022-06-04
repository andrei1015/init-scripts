<?php
error_reporting(0);

// Variables you can change
$GITHUB_TOKEN = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx';
$GIT_NAME = 'username';
$GIT_EMAIL = 'you@email.com';
$WEBSITE = 'domain.com';

$PMA_ROOT_PASS = 'pma_root_pass';
$PMA_USER_PASS = 'pma_user_pass';

$MATOMO_DB = 'matomo_db';
$MATOMO_USER = 'matomo-db-use';
$MATOMO_PASS = 'super-secure-passwor';

$WORDPRESS_DB = 'wordpress_database';
$WORDPRESS_USER = 'wordpress-database-user';
$WORDPRESS_PASS = md5('super-secure-password-again-secret');
// Don't change anything thank the above variables

// var_dump($argv);

function replace_in_file($FilePath, $OldText, $NewText)
{
    $Result = array('status' => 'error', 'message' => '');
    if(file_exists($FilePath)===TRUE)
    {
        if(is_writeable($FilePath))
        {
            try
            {
                $FileContent = file_get_contents($FilePath);
                $FileContent = str_replace($OldText, $NewText, $FileContent);
                if(file_put_contents($FilePath, $FileContent) > 0)
                {
                    $Result["status"] = 'success';
                }
                else
                {
                   $Result["message"] = 'Error while writing file';
                }
            }
            catch(Exception $e)
            {
                $Result["message"] = 'Error : '.$e;
            }
        }
        else
        {
            $Result["message"] = 'File '.$FilePath.' is not writable !';
        }
    }
    else
    {
        $Result["message"] = 'File '.$FilePath.' does not exist !';
    }
    return $Result;
}

if (!$argv[1]) {
    echo 'argument missing'.PHP_EOL;
    die();
}
elseif ($argv[1] === 'matomo') {
    if ($MATOMO_DB === 'matomo_db' || $MATOMO_USER === 'matomo-db-user' || $MATOMO_PASS === 'super-secure-password') {
        echo 'matomo credentials haven\'t (all?) changed'.PHP_EOL;
        die();
    }
    else {
        replace_in_file('files/matomo-config.php.ini','MATOMO_USER', $MATOMO_USER);
        replace_in_file('files/matomo-config.php.ini','MATOMO_PASS', $MATOMO_PASS);
        replace_in_file('files/matomo-config.php.ini','MATOMO_DB', $MATOMO_DB);
        replace_in_file('files/matomo.sql','MATOMO_DB', $MATOMO_DB);
        replace_in_file('files/matomo.sql','MATOMO_USER', $MATOMO_USER);
        replace_in_file('files/matomo.sql','MATOMO_PASS', $MATOMO_PASS);
        echo 'matomo config done'.PHP_EOL;
    }
}
elseif ($argv[1] === 'wordpress') {
    if ($WORDPRESS_DB === 'wordpress_db' || $WORDPRESS_USER === 'wordpress-db-user' || $WORDPRESS_PASS === md5('super-secure-password-again')) {
        echo 'wordpress credentials haven\'t (all?) changed'.PHP_EOL;
        die();
    }
    else {
        replace_in_file('files/wordpress-config.php','WORDPRESS_DB', $WORDPRESS_DB);
        replace_in_file('files/wordpress-config.php','WORDPRESS_USER', $WORDPRESS_USER);
        replace_in_file('files/wordpress-config.php','WORDPRESS_PASS', $WORDPRESS_PASS);
        replace_in_file('files/wordpress.sql','WORDPRESS_DB', $WORDPRESS_DB);
        replace_in_file('files/wordpress.sql','WORDPRESS_USER', $WORDPRESS_USER);
        replace_in_file('files/wordpress.sql','WORDPRESS_PASS', $WORDPRESS_PASS);
        echo 'wordpress config done'.PHP_EOL;
    }
}
elseif ($argv[1] === 'phpmyadmin') {
    if ($PMA_ROOT_PASS = 'pma_root_pass' || $PMA_USER_PASS = 'pma_user_pass') {
        echo 'phpmyadmin credentials haven\'t (all?) changed'.PHP_EOL;
        die();
    }
    else {
        replace_in_file('server-stack.sh','PMA_ROOT_PASS', $$PMA_ROOT_PASS);
        replace_in_file('files/phpmyadmin.sql','PMA_USER_PASS', $PMA_USER_PASS);
        replace_in_file('files/wordpress-config.php','WORDPRESS_PASS', $WORDPRESS_PASS);
        replace_in_file('files/wordpress.sql','WORDPRESS_DB', $WORDPRESS_DB);
        replace_in_file('files/wordpress.sql','WORDPRESS_USER', $WORDPRESS_USER);
        replace_in_file('files/wordpress.sql','WORDPRESS_PASS', $WORDPRESS_PASS);
        echo 'wordpress config done'.PHP_EOL;
    }
}
else {
    echo 'unknown argument'.PHP_EOL;
}
?>