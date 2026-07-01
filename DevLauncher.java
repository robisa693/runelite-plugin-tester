import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class DevLauncher
{
    public static void main(String[] args) throws Exception
    {
        Path repositoryDir = Paths.get(System.getProperty("user.home"), ".runelite", "repository2");
        if (!Files.isDirectory(repositoryDir))
        {
            System.err.println("RuneLite repository not found at: " + repositoryDir);
            System.err.println("Run the official RuneLite.jar at least once to populate it.");
            System.exit(1);
        }

        List<URL> jarUrls = new ArrayList<>();

        File self = new File(DevLauncher.class.getProtectionDomain().getCodeSource().getLocation().toURI());
        File selfDir = self.getParentFile();

        File runeLiteJar = new File(selfDir, "RuneLite.jar");
        if (runeLiteJar.isFile())
        {
            jarUrls.add(runeLiteJar.toURI().toURL());
        }

        File[] repoJars = repositoryDir.toFile().listFiles((dir, name) -> name.endsWith(".jar"));
        if (repoJars != null)
        {
            for (File jar : repoJars)
            {
                jarUrls.add(jar.toURI().toURL());
            }
        }

        URL[] urls = jarUrls.toArray(new URL[0]);
        URLClassLoader loader = new URLClassLoader(urls, ClassLoader.getSystemClassLoader());
        loader.setDefaultAssertionStatus(true);

        Thread.currentThread().setContextClassLoader(loader);

        Class<?> clientClass = loader.loadClass("net.runelite.client.RuneLite");
        Method mainMethod = clientClass.getMethod("main", String[].class);
        mainMethod.invoke(null, new Object[]{new String[]{"--developer-mode"}});
    }
}
