<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'redirect_locale')]
    public function redirectToDefaultLocale(): \Symfony\Component\HttpFoundation\RedirectResponse
    {
        return $this->redirectToRoute('app_home', ['_locale' => 'da']);
    }

    #[Route('/{_locale}', name: 'app_home', requirements: ['_locale' => 'da|en'])]
    public function index(): Response
    {


        return $this->render('home/index.html.twig', [
            'controller_name' => 'HomeController',
        ]);
    }
}
